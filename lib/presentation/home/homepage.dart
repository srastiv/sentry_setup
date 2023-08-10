import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sentry_poc/core/navigation/app_router.gr.dart';
import 'package:sentry_poc/core/sentry/sentry_reporter.dart';

@RoutePage()
class MyHomePageScreen extends StatefulWidget {
  const MyHomePageScreen({
    super.key,
  });
  final String title = "Title";

  @override
  State<MyHomePageScreen> createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              ElevatedButton(
                  onPressed: () => context.pushRoute(const NumberSwapRoute()),
                  child: const Text('Go to NUMBER SWAP Screen')),
              ElevatedButton(
                  onPressed: () => context.pushRoute(const NumberUpdateRoute()),
                  child: const Text('Go to NUMBER UPDATE Screen')),
              ElevatedButton(
                  onPressed: () => context.pushRoute(const DigitUpdateRoute()),
                  child: const Text('Go to DIGIT UPDATE Screen')),
              ElevatedButton(
                  onPressed: () => SentryReporter.setupPerformance(
                        transactionName: 'T3',
                        operation: 'Third transaction',
                      ),
                  child: const Text('T3')),
              ElevatedButton(
                  onPressed: () => SentryReporter.setupPerformance(
                        transactionName: 'T2',
                        operation: 'second transaction',
                      ),
                  child: const Text('T2')),
              ElevatedButton(
                  onPressed: () => SentryReporter.loadUserDataOnClick(),
                  child: const Text('Load User Data')),
              TextButton(
                  onPressed: () async => await throwDartException(),
                  child: const Text('Dart Exception')),
              TextButton(
                  onPressed: () async => await throwAsyncDartException(),
                  child: const Text('Async dart Exception')),
              ElevatedButton(
                  onPressed: () => context.pushRoute(const ApiRoute()),
                  child: const Text('Go to API Screen')),
              ElevatedButton(
                  onPressed: () => context.pushRoute(const WebsocketRoute()),
                  child: const Text('Go to WEBSOCKET Screen')),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag:
                'send_error_button', // Assign a unique tag for the FloatingActionButton
            onPressed: _aMethodThatMightFail,
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Text('Send error'),
            ),
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  int _aMethodThatMightFail() {
    int? test;
    try {
      test! + 3; // this will fail because i am adding 3 to null value
      return test;
    } catch (exception, stackTrace) {
      SentryReporter.genericThrow(
        'Method Actually Failed',
        exception,
        stackTrace,
      );
    }
    return test ?? 0;
  }

  Future throwDartException() async {
    try {
      throw StateError('Dart Exception');
    } catch (exception, stackTrace) {
      SentryReporter.genericThrow('Dart Exception', exception, stackTrace);
    }
  }

  Future throwAsyncDartException() async {
    try {
      foo() async {
        throw StateError('Async dart exception in state');
      }

      bar() async {
        await foo();
      }

      await bar();
    } catch (e, stackTrace) {
      SentryReporter.genericThrow('Async dart exc', e, stackTrace);
    }
  }
}
