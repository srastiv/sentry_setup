
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SwapNumbersWidget extends StatefulWidget {
  const SwapNumbersWidget({super.key});

  @override
  State<SwapNumbersWidget> createState() => _SwapNumbersWidgetState();
}

class _SwapNumbersWidgetState extends State<SwapNumbersWidget>
    with SingleTickerProviderStateMixin {
  final List<int> numbers = [0, 10, 26, 55, 99, 107, 888, 1000, 10000];
  final ValueNotifier<List<int>> _numberList = ValueNotifier<List<int>>([]);
  late AnimationController _animationController;
  late int _currentIndex;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _numberList.value = List.from(numbers);

    _currentIndex = _numberList.value.indexOf(0);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _startRandomSwap();
    });
  }

  @override
  void dispose() {
    _numberList.dispose();
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startRandomSwap() {
    final random = Random();

    // Select a random index to swap with the middle position
    int indexToSwap = random.nextInt(numbers.length - 2) +
        1; // Exclude first and last positions
    int middleIndex = numbers.length ~/ 2;

    // Swap the values at the selected index and middle position
    final List<int> newList = List.from(_numberList.value);
    int temp = newList[indexToSwap];
    newList[indexToSwap] = newList[middleIndex];
    newList[middleIndex] = temp;
    setState(() {
      _currentIndex = indexToSwap;
    });

    _animationController.reset();
    _animationController.forward();

    // Update the list with the swapped elements and trigger the animation
    _numberList.value = newList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
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
      child: Column(
        children: [
          ValueListenableBuilder<List<int>>(
            valueListenable: _numberList,
            builder: (context, list, child) {
              return Column(
                children: [
                  for (var index = 0; index < list.length; index++)
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(
                          0,
                          index == _currentIndex
                              ? (_currentIndex < list.length ~/ 2 ? -0.5 : 0.5)
                              : 0,
                        ),
                        end: const Offset(0, 0),
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      )),
                      child: Container(
                        key: ValueKey<int>(index),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          list[index].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}



  // SlideTransition(
//                       position: Tween<Offset>(
//                         begin: const Offset(0, 0),
//                         end: _currentIndex == index
//                             ? Offset(0, _currentIndex < middleIndex ? 1 : -1)
//                             : Offset(0, index < middleIndex ? -1 : 0),
//                       ).animate(CurvedAnimation(
//                         parent: _animationController,
//                         curve: Curves.easeInOut,
//                       )),