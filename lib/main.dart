import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PinSetupScreen(),
    );
  }
}

class PinSetupScreen extends StatefulWidget {
  @override
  _PinSetupScreenState createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String pin = '';

  void _onNumberPressed(String number) {
    setState(() {
      if (pin.length < 4) {
        pin += number;
      }
      // If the PIN is complete, you can handle it here (e.g., save to storage)
      if (pin.length == 4) {
        // Handle the PIN (e.g., save to storage, navigate to the next screen)
        print('PIN set: $pin');
      }
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: const Text(
          'PIN Setup',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 24),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        primary: true,
        children: [
          const SizedBox(height: 24),
          const Text(
            'PIN for your device or account',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'A simple step to improve security and convenience when you’re using offline check-out.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 59),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 4; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: i < pin.length ? 6 : 0,
                      color: i < pin.length ? Colors.green : Colors.transparent,
                    ),
                    shape: BoxShape.circle,
                    color: i < pin.length ? Colors.white : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 59),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (int i = 1; i <= 9; i++)
                NumberButton(
                  number: '$i',
                  onPressed: () => _onNumberPressed('$i'),
                ),
              IconButton(
                onPressed: () {},
                icon: const  Icon(
                  Icons.fingerprint,
                ),
                iconSize: 46,
                color: Colors.green,
              ),
              NumberButton(
                number: '0',
                onPressed: () => _onNumberPressed('0'),
              ),
              IconButton(
                onPressed: _onDeletePressed,
                icon: const Icon(
                  Icons.backspace_outlined,
                ),
                iconSize: 36,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NumberButton extends StatefulWidget {
  final String number;
  final VoidCallback onPressed;

  const NumberButton({
    Key? key,
    required this.number,
    required this.onPressed,
  }) : super(key: key);

  @override
  _NumberButtonState createState() => _NumberButtonState();
}

class _NumberButtonState extends State<NumberButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
        widget.onPressed();
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPressed ? Colors.green : Colors.grey.shade300,
        ),
        child: Center(
          child: Text(
            widget.number,
            style: const TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
