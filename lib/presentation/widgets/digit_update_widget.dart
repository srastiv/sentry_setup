import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:odometer/odometer.dart';

class DigitUpdateWidget extends StatefulWidget {
  const DigitUpdateWidget({Key? key}) : super(key: key);

  @override
  State<DigitUpdateWidget> createState() => _DigitUpdateWidgetState();
}

class _DigitUpdateWidgetState extends State<DigitUpdateWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  late Animation<OdometerNumber> animation;
  int _currentIndex = 0;
  final List<int> numbers = [
    0,
    1,
    5,
    8,
    10,
    15,
    18,
    90,
    94,
    97,
    99,
    100,
    103,
    107,
    700,
    750,
    887,
    888,
    996,
    997,
    998,
    999,
    1000,
    1234,
    1235,
    1236,
    2000,
    2001,
    2002,
    2003,
    9000,
    9001,
    9997,
    9998,
    9999,
    10000,
    12345,
  ];

  @override
  void initState() {
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = OdometerTween(
      begin: OdometerNumber(numbers[0]),
      end: OdometerNumber(numbers[1]),
    ).animate(
      CurvedAnimation(curve: Curves.easeIn, parent: animationController!),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Odometer package',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 8),
          AnimatedSlideOdometerNumber(
            letterWidth: 20,
            odometerNumber: OdometerNumber(numbers[_currentIndex]),
            duration: const Duration(seconds: 1),
            numberTextStyle: const TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: SlideOdometerTransition(
              letterWidth: 20,
              odometerAnimation: animation,
              numberTextStyle: const TextStyle(fontSize: 20),
            ),
          ),
          const Divider(thickness: 2, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_currentIndex > 0) {
                    setState(() {
                      _currentIndex--;
                      animation = OdometerTween(
                        begin: OdometerNumber(numbers[_currentIndex]),
                        end: OdometerNumber(numbers[_currentIndex + 1]),
                      ).animate(
                        CurvedAnimation(
                            curve: Curves.easeIn, parent: animationController!),
                      );
                    });
                    animationController!.reverse();
                  }
                },
                child: const Text('Reverse'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_currentIndex < numbers.length - 2) {
                    setState(() {
                      _currentIndex++;
                      animation = OdometerTween(
                        begin: OdometerNumber(numbers[_currentIndex]),
                        end: OdometerNumber(numbers[_currentIndex + 1]),
                      ).animate(
                        CurvedAnimation(
                            curve: Curves.easeIn, parent: animationController!),
                      );
                    });
                    animationController!.forward();
                  }
                },
                child: const Text('Forward'),
              ),
            ],
          ),
          const Divider(thickness: 2, height: 24),
          const Text(
            'Animated Flip Counter package',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: 8),
          AnimatedFlipCounter(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            value: numbers[_currentIndex],
            prefix: "Level",
            decimalSeparator: '.',
            textStyle: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              letterSpacing: -8.0,
              color: Color.fromARGB(255, 150, 111, 228),
              shadows: [
                BoxShadow(
                  color: Color.fromARGB(255, 226, 203, 49),
                  offset: Offset(4, 4),
                  blurRadius: 8,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
