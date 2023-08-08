import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sentry_poc/core/sentry/sentry_reporter.dart';
// import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:web_socket_channel/io.dart';

@RoutePage()
class WebsocketScreen extends StatefulWidget {
  const WebsocketScreen({super.key});

  @override
  State<WebsocketScreen> createState() => _WebsocketScreenState();
}

class _WebsocketScreenState extends State<WebsocketScreen> {
  // dummy websocket
  final channel =
      IOWebSocketChannel.connect('wss://socketsbay.com/wss/v2/1/demo/');
  final TextEditingController _controller = TextEditingController();

  void sendData() async {
    channel.sink.add(_controller.text);
  }

  @override
  void dispose() {
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Websocket screen'),
      ),
      body: Column(
        children: [
          Form(
            child: TextFormField(
              decoration: const InputDecoration(
                  labelText: "Send any message to the server"),
              controller: _controller,
            ),
          ),
          TextButton(
            onPressed: () {
              sendData();
              _controller.clear();
              SentryReporter.setupPerformance(
                  transactionName: 'Send to Socket',
                  operation: 'Message',
                  description: 'Sending message to a dummy websocket');
            },
            child: const Text('send to websocket'),
          ),
          Expanded(
            child: StreamBuilder(
              stream: channel
                  .stream, // channel.stream is an in-built method to fetch data
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    snapshot.hasData ? '${snapshot.data}' : 'No data yet',
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
