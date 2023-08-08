import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_poc/presentation/api_screen/api_bloc/api_bloc.dart';

@RoutePage()
class ApiScreen extends StatelessWidget {
  const ApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: BlocProvider(
        create: (context) => ApiBloc(),
        child: BlocBuilder<ApiBloc, ApiState>(
          builder: (context, state) {
            if (state is ApiInitial) {
              BlocProvider.of<ApiBloc>(context).add(FetchApiEvent());
            }
            if (state is ApiLoadedState) {
              return Column(
                children: [
                  SizedBox(
                    height: 400,
                    width: 400,
                    child: ListView.builder(
                        itemCount:
                            (state.list.length) > 10 ? 10 : state.list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(state.list[index].id.toString()),
                            trailing: Text(state.list[index].title),
                          );
                        }),
                  ),
                  ElevatedButton(
                      onPressed: () async =>
                          showDialogWithTextAndImage(context),
                      child: const Text('Show popup')),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<void> showDialogWithTextAndImage(BuildContext context) async {
    final transaction = Sentry.getSpan() ??
        Sentry.startTransaction(
          'asset-bundle-transaction',
          'load',
          bindToScope: true,
        );
    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      // gets tracked if using SentryNavigatorObserver
      routeSettings: const RouteSettings(
        name: 'AssetBundle dialog',
      ),
      builder: (context) {
        return AlertDialog(
          title: const Text('Asset Example'),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('yes'),
              ],
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            )
          ],
        );
      },
    );
    await transaction.finish(status: const SpanStatus.ok());
  }
}
