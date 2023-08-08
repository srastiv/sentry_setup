import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_poc/core/sentry/sentry_reporter.dart';
import 'package:sentry_poc/core/navigation/app_router.dart';

Future<void> main() async {
  await SentryReporter.setup(const MyApp());
}

class MyApp extends StatelessWidget {
  static final AppRouter appRouter = AppRouter();
  const MyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.config(
        navigatorObservers: () => [
          SentryNavigatorObserver(
            setRouteNameAsTransaction: true,
          ),
        ],
      ),

      //Automatic routing instrumentation can be enabled by
      // adding an instance of SentryNavigationObserver to
      // your application's navigatorObservers. Transactions
      // are started automatically when routing to new pages
      // in your application.

      // navigatorObservers: [
      //   SentryNavigatorObserver(setRouteNameAsTransaction: true)
      // ],

      // The main route of your application will have
      // the name root "/". In order for transactions
      // to be created automatically when navigation
      // changes, you need to provide route names through
      // your routes settings parameter.

      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
