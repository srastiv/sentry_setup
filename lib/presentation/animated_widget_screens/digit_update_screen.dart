import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:sentry_poc/presentation/widgets/digit_update_widget.dart';

@RoutePage()
class DigitUpdateScreen extends StatefulWidget {
  const DigitUpdateScreen({super.key});

  @override
  State<DigitUpdateScreen> createState() => _DigitUpdateScreenState();
}

class _DigitUpdateScreenState extends State<DigitUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const DigitUpdateWidget(),
    );
  }
}
