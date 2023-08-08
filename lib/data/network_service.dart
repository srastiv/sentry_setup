import 'package:dartz/dartz.dart';
import 'package:sentry_poc/core/interceptor/failure.dart';
import 'package:sentry_poc/core/interceptor/sentry_interceptor.dart';
import 'package:sentry_poc/domain/photos_model.dart';

Future<Either<Failure, List<FetchPostsModel>>> fetchPosts() async {
  final SentryInterceptor sentryInterceptor = SentryInterceptor();

  const String url = 'https://jsonplaceholder.typicode.com/posts';
  var response = await sentryInterceptor.request(
    url: url,
    method: Method.get,
  );
  return response.fold((l) => Left(l), (r) {
    final result = List<FetchPostsModel>.from(
        ((r.data) as List).map((x) => FetchPostsModel.fromJson(x)));

    return Right(result);
  });
}
