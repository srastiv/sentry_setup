import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'store_dsn.dart';

class SentryReporter {
  late Sentry sentry;
  static Future<void> setup(Widget child) async {
    const String sentryDSN = StoreStrings.sentryDSN;

// initialise sentryclient
    // SentryClient sentry = SentryClient(SentryOptions(dsn: sentryDSN));
    // if (kReleaseMode) {
    await SentryFlutter.init(
      (SentryFlutterOptions options) {
        // DSN stands 'Data Source Name'. It includes protocol, public key,
        // server address, project identifier. Its not a URL, it is a
        // representation of the configuration required by Sentry SDKs.
        options.dsn = sentryDSN;

        // Set tracesSampleRate to 1.0 to capture 100% of
        // transactions for performance monitoring.
        // Recommended to adjust this value in production.

        //Changing the error sample rate requires re-deployment
        // If set to 0.1 only 10% of error events will be sent.

        // Sampling allows to better manage the
        // number of events sent to Sentry
        options.sampleRate = 1;
        options.maxBreadcrumbs = 50; // default 100
        options.enableAutoSessionTracking = true;
        options.autoSessionTrackingInterval =
            const Duration(milliseconds: 60000);
        options.beforeSend = _beforeSendingError;

        //The two options (tracesSampler and tracesSampleRate)
        // are meant to be mutually exclusive.
        // If you set both, tracesSampler will take precedence.
        // options.tracesSampler = _tracesSampler;
        options.tracesSampleRate = 1; //uniform sample rate for all transactions

        // For capturing native crashes that occur prior to
        // the init method being called on the Flutter layer.
        // defaults to true
        options.autoInitializeNativeSdk = true;

        // The transaction finishes automatically after it
        // reaches the specified idleTimeout and all of its
        // child spans are finished. default 3 seconds
        options.idleTimeout = const Duration(milliseconds: 3000);

        //PII stands for Personally Identifiable Information.
        options.sendDefaultPii = true; // to get Widget labels, text, and so on
        // Environments tell you where an error occurred
        // Environments are case sensitive. You can't delete
        // environments, but you can hide them.
        // options.environment = 'staging';
        options.enableAutoPerformanceTracing = true;
        options.enableUserInteractionTracing = true; // true by default
        //wrap MyApp with SentryUserInteractionWidget

        options.attachScreenshot = true;
        options.screenshotQuality = SentryScreenshotQuality.low;
        // wrap MyApp with SentryScreenshotWidget
      },
      appRunner: () => runApp(
        // The AssetBundle instrumentation provides insight
        // into how long your app takes to load its assets, such as files.
        SentryScreenshotWidget(
          child: SentryUserInteractionWidget(
            child: DefaultAssetBundle(
              bundle: SentryAssetBundle(),
              child: child,
            ),
          ),
        ),
      ),
    );
    // }  else {
    //    runApp(MyApp());
    // }
  }

  static genericThrow(String message, Object exception, stackTrace) async {
    if (stackTrace != null) {
      // logging the error to the console here
      log(exception.toString());
      log(message);
      Sentry.captureException(
        hint: Hint(),
        exception,
        stackTrace: stackTrace,
      );
    } else {
      Sentry.captureException(exception);
    }
  }

  static void captureMessage(String message) async {
    log(message);
    await Sentry.captureMessage(message);
  }

  static FutureOr<SentryEvent?> _beforeSendingError(SentryEvent event,
      {Hint? hint}) async {
    // static _beforeSendingError(SentryEvent event) {
    // Use this method to modify/filter the event before sending it to Sentry.
    // For example, you can modiy user details from an event.

    if (event.user != null) {
      // perform an action
      event = event.copyWith(serverName: null); // Don't send server names.
    }

    // The fingerprintThe set of characteristics that define an event.
    // It is forced to a common value if an exception of a certain type has been caught
    // if (event.throwable is DatabaseException) {
    //   event = event.copyWith(fingerprint: ['database-connection-error']);
    // }
    return event;
  }

// a transaction refers to a specific type of data capture
// that represents a single logical operation or task.
// can mark certain sections of your code as transactions.
// These sections could be specific API calls, database queries,
// or any other significant operation within your application.

// software performance, measuring metrics like throughput
// and latency, and displaying the impact of errors across
// multiple systems.

  static setupPerformance({
    required String transactionName,
    required String operation,
    String? description,
    Map<String, dynamic>? customSamplingContext,
  }) async {
    final ISentrySpan transaction = Sentry.startTransaction(
      transactionName, // 'A Transaction Name',
      operation, // 'The operation it will perform',
      description: description, // description of this transaction,
      customSamplingContext: {
        'userName': 'Srasti',
        'task': 'POC',
      },
      bindToScope: true,
    );
    try {
      await processOrderBatch(
        span: transaction,
        transactionName: transactionName,
        operation: operation,
      );
    } catch (exception) {
      transaction.throwable = exception;
      // one of the many methods provided by sentry for logging the type of error
      transaction.status = const SpanStatus.internalError();
    } finally {
      // Each individual span needs to be manually finished.
      // Spans are sent together with their parent transaction
      // when the transaction is finished. Make sure to call
      // finish() on transaction once all the child spans have finished.

      await transaction.finish();
    }
  }

  static Future<void> processOrderBatch({
    required ISentrySpan span,
    required String transactionName,
    required String operation,
  }) async {
    // ISentrySpan Represents performance monitoring Span.
    final innerSpan = span.startChild(operation, description: transactionName);
    try {
      // omitted code
    } catch (exception) {
      innerSpan.throwable = exception;
      innerSpan.status = const SpanStatus.notFound();
    } finally {
      await innerSpan.finish();
    }
  }

  static Future<void> loadUserDataOnClick() async {
    final span = Sentry.getSpan();
    final innerSpan = span?.startChild('loadUserData');
    // omitted code
    await innerSpan?.finish();
  }

  static double tracesSampler(SentrySamplingContext samplingContext) {
    // For controlling the sample rate based on the
    // transaction itself and the context in which
    // it's captured, by providing a function to the
    // tracesSampler config option.
    final ctx = samplingContext.customSamplingContext;

    final parentSampled =
        samplingContext.transactionContext.parentSamplingDecision?.sampled;
    if (parentSampled != null) {
      return parentSampled ? 1.0 : 0.0;
    }

    if ('/payment' == ctx['url']) {
      // These are important - take a big sample
      return 0.5;
    } else if ('/search' == ctx['url']) {
      // Search is less important and happen much more frequently - only take 1%
      return 0.01;
    } else if ('/health' == ctx['url']) {
      // The health check endpoint is just noise - drop all transactions
      return 0.0;
    } else {
      // Default sample rate
      return 0.1;
    }
  }

// To identify the user:
  void identifyUser(String userId, String userEmail) {
    Sentry.configureScope(
      (scope) => scope.setUser(SentryUser(id: userId, email: userEmail)),
    );
  }

//Clear the currently set user:
  void clearUser() {
    Sentry.configureScope((scope) => scope.setUser(null));
  }
}
