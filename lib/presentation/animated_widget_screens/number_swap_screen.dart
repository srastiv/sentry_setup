import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:sentry_poc/presentation/widgets/swap_number_widget.dart';

@RoutePage()
class NumberSwapScreen extends StatefulWidget {
  const NumberSwapScreen({super.key});

  @override
  State<NumberSwapScreen> createState() => _NumberSwapScreenState();
}

class _NumberSwapScreenState extends State<NumberSwapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: SwapNumbersWidget(),
      ),
    );
  }
}
