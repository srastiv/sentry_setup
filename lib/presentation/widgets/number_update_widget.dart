import 'dart:async';

import 'package:flutter/material.dart';

class NumberUpdateWidget extends StatefulWidget {
  const NumberUpdateWidget({Key? key}) : super(key: key);

  @override
  State<NumberUpdateWidget> createState() => _NumberUpdateWidgetState();
}

class _NumberUpdateWidgetState extends State<NumberUpdateWidget>
    with SingleTickerProviderStateMixin {
  final List<int> numbers = [0, 1, 5, 7, 10, 26, 55, 99, 107, 888, 1000, 10000];
  final ValueNotifier<int> _numberNotifier = ValueNotifier<int>(2);
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Start a timer to update the number and trigger animation
    Timer.periodic(const Duration(seconds: 1), (timer) {
      final randomIndex = numbers.indexOf(_numberNotifier.value);
      final newRandomIndex =
          (randomIndex + 1) % numbers.length; // Circular indexing
      _updateNumber(numbers[newRandomIndex]);
    });
  }

  @override
  void dispose() {
    _numberNotifier.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateNumber(int newNumber) {
    _animationController.reset();
    _numberNotifier.value = newNumber;
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: ValueListenableBuilder<int>(
          valueListenable: _numberNotifier,
          builder: (context, number, child) {
            return Center(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                )),
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 32,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
