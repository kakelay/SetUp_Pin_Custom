import 'package:flutter/material.dart';
import 'package:setup_custom/views/jotpark.dart';

class PinSetupPageView extends StatefulWidget {
  const PinSetupPageView({super.key});

  @override
  _PinSetupPageViewState createState() => _PinSetupPageViewState();
}

class _PinSetupPageViewState extends State<PinSetupPageView>
    with SingleTickerProviderStateMixin {
  String pin = '';
  int attempts = 0;
  bool isLocked = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    if (isLocked) {
      _showLockedMessage();
      return;
    }

    setState(() {
      if (pin.length < 4) {
        pin += number;
      }

      // If the PIN is complete, you can handle it here (e.g., check for correctness)
      if (pin.length == 4) {
        _checkPin();
      }
    });
  }

  void _checkPin() {
    // Replace '1234' with your correct PIN
    if (pin == '1234') {
      _navigateToJotPark();
    } else {
      attempts++;
      if (attempts >= 6) {
        _lockAccount();
      }
      // Handle incorrect PIN (e.g., show an error message and shake animation)
      _showIncorrectPinMessage();
      _shakeController.forward(from: 0);
      // You can reset the pin after an incorrect attempt if needed
      pin = '';
    }
  }

  void _onDeletePressed() {
    setState(() {
      if (pin.isNotEmpty) {
        pin = pin.substring(0, pin.length - 1);
      }
    });
  }

  void _navigateToJotPark() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JotParkPage()),
    ).then((value) {
      // This code will run when the JotParkPage is popped and the user returns to this page
      // Reset the pin when returning from the JotParkPage
      setState(() {
        pin = '';
      });
    });
  }

  void _lockAccount() {
    setState(() {
      isLocked = true;
    });

    Future.delayed(const Duration(minutes: 1), () {
      setState(() {
        isLocked = false;
        attempts = 0;
      });
    });
  }

  void _showLockedMessage() {
    // You can display a message indicating that the account is locked
    print('Account is locked. Try again in 1 minute.');
  }

  void _showIncorrectPinMessage() {
    // You can display a message indicating that the PIN is incorrect
    print('Incorrect PIN. Attempts left: ${6 - attempts}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Setup PIN',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        actions: [
          if (isLocked)
            TextButton(onPressed: () {}, child: const Text('reset password'))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Column(
              children: [
                Text(
                  'PIN for your device or account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'A simple step to improve security and convenience when you’re using offline check-out.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 4; i++)
                  AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_shakeAnimation.value, 0),
                        child: child,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: i < pin.length ? 6 : 0,
                          color: i < pin.length
                              ? Colors.green
                              : Colors.transparent,
                        ),
                        shape: BoxShape.circle,
                        color: i < pin.length
                            ? Colors.white
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
              ],
            ),
            if (isLocked)
              const SizedBox(
                height: 20,
                child: Text(
                  'Try again in 1 minute',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              const SizedBox(
                height: 20,
              ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.count(
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
                        icon: const Icon(
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
                ),
              ],
            ),
            const SizedBox(height: 5)
          ],
        ),
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
        margin: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPressed ? Colors.green.shade400 : Colors.grey.shade300,
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
