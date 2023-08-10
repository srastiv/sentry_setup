import 'dart:async';
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
  final StreamController<List<double>> _numbersStreamController =
      StreamController<List<double>>();

  AnimationController? animationController;
  late Animation<OdometerNumber> animation;
  int _currentIndex = 0;
  final List<double> numbers = [
    0,
    -1.2,
    5.23,
    -8.5,
    10.6,
    -15.76,
    18.87,
    -90.11,
    94.23,
    -97.76,
    99.26,
    -100.99,
    103.76,
    -107.09,
    700.16,
    -750.4,
    887,
    -888,
    996,
    -997.35,
    998,
    -999,
    1000,
    -1234,
    1235.35,
    -1236,
    2000,
    -2001,
    2002.54,
    -2003,
    9000.53,
    -9001,
    9997,
    -9998,
    9999.35,
    -10000.34,
    12345,
  ];

  @override
  void initState() {
    _numbersStreamController.add(numbers);

    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = OdometerTween(
      begin: OdometerNumber(numbers[0].toInt()),
      end: OdometerNumber(numbers[1].toInt()),
    ).animate(
      CurvedAnimation(curve: Curves.easeIn, parent: animationController!),
    );

    // Shuffle the numbers list
    numbers.shuffle();

    // Automatically update the numbers every few seconds
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentIndex < numbers.length - 2) {
        setState(() {
          _currentIndex++;
          animation = OdometerTween(
            begin: OdometerNumber(numbers[_currentIndex].toInt()),
            end: OdometerNumber(numbers[_currentIndex + 1].toInt()),
          ).animate(
            CurvedAnimation(curve: Curves.easeIn, parent: animationController!),
          );
        });
        animationController!.forward();
      } else {
        // Restart animation when numbers reach the end
        setState(() {
          _currentIndex = 0;
          animation = OdometerTween(
            begin: OdometerNumber(numbers[numbers.length - 1].toInt()),
            end: OdometerNumber(numbers[0].toInt()),
          ).animate(
            CurvedAnimation(curve: Curves.easeIn, parent: animationController!),
          );
        });
        animationController!.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _numbersStreamController.close();
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<List<double>>(
        stream: _numbersStreamController.stream,
        builder: (context, AsyncSnapshot<List<double>> snapshot) {
          if (snapshot.hasData) {
            final numbersList = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Odometer package',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const SizedBox(height: 8),
                AnimatedSlideOdometerNumber(
                  letterWidth: 20,
                  odometerNumber:
                      OdometerNumber(numbersList[_currentIndex].toInt()),
                  duration: const Duration(milliseconds: 300),
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     ElevatedButton(
                //       onPressed: () {
                //         if (_currentIndex > 0) {
                //           setState(() {
                //             _currentIndex--;
                //             animation = OdometerTween(
                //               begin: OdometerNumber(numbersList[_currentIndex]),
                //               end: OdometerNumber(
                //                   numbersList[_currentIndex + 1]),
                //             ).animate(
                //               CurvedAnimation(
                //                   curve: Curves.easeIn,
                //                   parent: animationController!),
                //             );
                //           });
                //           animationController!.reverse();
                //         }
                //       },
                //       child: const Text('Reverse'),
                //     ),
                //     ElevatedButton(
                //       onPressed: () {
                //         if (_currentIndex < numbersList.length - 2) {
                //           setState(() {
                //             _currentIndex++;
                //             animation = OdometerTween(
                //               begin: OdometerNumber(numbersList[_currentIndex]),
                //               end: OdometerNumber(
                //                   numbersList[_currentIndex + 1]),
                //             ).animate(
                //               CurvedAnimation(
                //                   curve: Curves.easeIn,
                //                   parent: animationController!),
                //             );
                //           });
                //           animationController!.forward();
                //         }
                //       },
                //       child: const Text('Forward'),
                //     ),
                //   ],
                // ),
                const Divider(thickness: 2, height: 24),
                const Text(
                  'Animated Flip Counter package',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const SizedBox(height: 8),
                AnimatedFlipCounter(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  value: numbersList[_currentIndex],
                  prefix: "Level: ",
                  thousandSeparator: ',',
                  fractionDigits: 2,
                  curve: Curves.easeInOutCirc,
                  duration: const Duration(milliseconds: 300),
                  mainAxisAlignment: MainAxisAlignment.end,
                  textStyle: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -4.0,
                    color: numbersList[_currentIndex] > 0
                        ? const Color.fromARGB(255, 26, 149, 102)
                        : numbersList[_currentIndex] == 0
                            ? const Color.fromARGB(255, 130, 130, 130)
                            : const Color.fromARGB(255, 229, 42, 42),
                  ),
                ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
