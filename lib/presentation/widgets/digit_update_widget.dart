import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sentry_poc/presentation/widgets/animated_flip_counter.dart';

class DigitUpdateWidget extends StatefulWidget {
  const DigitUpdateWidget({Key? key}) : super(key: key);

  @override
  State<DigitUpdateWidget> createState() => _DigitUpdateWidgetState();
}

class _DigitUpdateWidgetState extends State<DigitUpdateWidget>
    with SingleTickerProviderStateMixin {
  final StreamController<double> _numbersStreamController =
      StreamController<double>();

  AnimationController? animationController;
  late Animation<double> animation;
  double randomValue = 0.0;
  double previousValue = 0.0;
  bool isAnimating = false;

  @override
  void initState() {
    randomValue = generateRandomValue();
    previousValue = randomValue;
    _numbersStreamController.add(randomValue);

    animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    animation = Tween<double>(
      begin: previousValue,
      end: randomValue,
    ).animate(
      CurvedAnimation(curve: Curves.easeIn, parent: animationController!),
    );

    // Listen for animation status changes
    animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController!.reset();
        animationController!.forward();
      }
    });
    // Start the initial animation
    animationController!.forward();

    // Use Timer.periodic to update animation and flip counter values
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        previousValue = randomValue;
        randomValue = generateRandomValue();
        _numbersStreamController.add(randomValue);
      });

      animation = Tween<double>(
        begin: previousValue,
        end: randomValue,
      ).animate(
        CurvedAnimation(curve: Curves.easeIn, parent: animationController!),
      );
      animationController!.forward(from: 0.0);
    });

    animationController!.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          isAnimating = true;
        });
      } else if (status == AnimationStatus.completed) {
        setState(() {
          isAnimating = false;
        });
      }
    });

    super.initState();
  }

  double generateRandomValue() {
    final random = Random();
    return (random.nextDouble() * 40001.0) - 20000.0;
  }

  @override
  void dispose() {
    _numbersStreamController.close();
    animationController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DigitUpdateWidget oldWidget) {
    print('ZZZZZZZ: ${oldWidget.key.toString()}');
    super.didUpdateWidget(oldWidget);

    randomValue = generateRandomValue();
    _numbersStreamController.add(randomValue);
    animation = Tween<double>(
      begin: previousValue,
      end: randomValue,
    ).animate(
      CurvedAnimation(curve: Curves.easeIn, parent: animationController!),
    );
    animationController!.forward(from: 0.0);
    previousValue = randomValue;
  }
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<double>(
        stream: _numbersStreamController.stream,
        builder: (context, AsyncSnapshot<double> snapshot) {
          if (snapshot.hasData) {
            final number = snapshot.data!;
            final textColor = textColour(
              isAnimating: isAnimating,
              currentNumber: animation.value, // Use animation value here
              nextNumber: number,
            );
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Animated Flip Counter package',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const SizedBox(height: 8),
                AnimatedFlipCounter(
                  key: const Key('animatedNumbers'),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  value: number,
                  suffix: ' %',
                  prefix: number > 0
                      ? 'Level: ▲'
                      : number == 0
                          ? "Level: "
                          : "Level: 🔻",
                  thousandSeparator: ',',
                  fractionDigits: 2,
                  curve: Curves.easeInOutCirc,
                  duration: const Duration(milliseconds: 300),
                  mainAxisAlignment: MainAxisAlignment.end,
                  textStyle: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -4.0,
                    color: textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {counter++;});
                  },
                  child: const Text('DID UPDATE WIDGET?'),
                ),
                Text(counter.toString()),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
        // did update widget
        // event bus
      ),
    );
  }

  Color textColour({
    required bool isAnimating,
    required double currentNumber,
    required double nextNumber,
  }) {
    if (isAnimating && currentNumber < nextNumber) {
      return const Color.fromARGB(255, 26, 149, 102);
    } else if (isAnimating && currentNumber > nextNumber) {
      return const Color.fromARGB(255, 229, 42, 42);
    }
    return const Color.fromARGB(255, 0, 0, 0);
  }
}
