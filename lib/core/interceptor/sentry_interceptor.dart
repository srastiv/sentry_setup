import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_poc/core/interceptor/failure.dart';
import 'package:sentry_poc/core/sentry/sentry_reporter.dart';

enum Method { post, get, put, delete, patch }

class SentryInterceptor extends Interceptor {
  final Dio _dio = Dio();
  late ISentrySpan transaction;

  SentryInterceptor() {
    initInterceptor();
  }

  void initInterceptor() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: onRequest,
      onResponse: onResponse,
      onError: onError,
    ));
  }

  @override
  dynamic onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    log('REQUEST[${options.method}] \n'
        '=> PATH: ${options.path} \n');

    transaction = Sentry.getSpan() ??
        Sentry.startTransaction(
          'API call : Fetch Posts',
          'API method: ${options.method}',
          bindToScope: true,
        );

    return handler.next(options);
  }

  @override
  dynamic onResponse(
    response,
    ResponseInterceptorHandler handler,
  ) async {
    log(
      'RESPONSE[${response.statusCode}] => DATA: ${response.data}',
    );
    await transaction.finish(status: const SpanStatus.ok());
    return handler.next(response);
  }

  @override
  dynamic onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    log(
      'Error[${err.response?.statusCode}] '
      '=> MESSAGE: ${err.response}',
    );
    await transaction.finish(
      status: err.response != null
          ? SpanStatus.fromHttpStatusCode(err.response!.statusCode!)
          : const SpanStatus.notFound(),
    );
    SentryReporter.genericThrow(
        'API photo fetching failed', err, StackTrace.current);

    return handler.next(err);
  }

  Future<Either<Failure, Response<dynamic>>> request({
    required String url,
    required Method method,
  }) async {
    if (method == Method.get) {
      Response<dynamic> response = await _dio.get(url);
      return Right(response);
    }
    return const Left(Failure(-1, 'FAILED FETCHING'));
  }
}
