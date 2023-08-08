import 'package:auto_route/auto_route.dart';
import 'package:sentry_poc/core/navigation/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          path: '/',
          page: MyHomePageRoute.page, 
        ),
        AutoRoute(
          page: ApiRoute.page, 
        ),
        AutoRoute(
          page: WebsocketRoute.page, 
        ),
      ];
}
