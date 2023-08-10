import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:sentry_poc/presentation/widgets/number_update_widget.dart';

@RoutePage()
class NumberUpdateScreen extends StatefulWidget {
  const NumberUpdateScreen({super.key});

  @override
  State<NumberUpdateScreen> createState() => _NumberUpdateScreenState();
}

class _NumberUpdateScreenState extends State<NumberUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: NumberUpdateWidget(),
      ),
    );
  }
}
