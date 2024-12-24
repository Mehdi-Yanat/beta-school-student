import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import localization

class VerificationBanner extends StatefulWidget {
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final int cooldownDuration; // Cooldown duration in seconds

  const VerificationBanner({
    Key? key,
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
    this.cooldownDuration = 60, // Default cooldown duration is 30 seconds
  }) : super(key: key);

  @override
  _VerificationBannerState createState() => _VerificationBannerState();
}

class _VerificationBannerState extends State<VerificationBanner> {
  int? remainingCooldownTime;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer
        ?.cancel(); // Ensure the timer is canceled when the widget is disposed
    super.dispose();
  }

  void startCooldown() {
    setState(() {
      remainingCooldownTime = widget.cooldownDuration;
    });

    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingCooldownTime == null || remainingCooldownTime! <= 0) {
        timer.cancel();
        setState(() {
          remainingCooldownTime = null; // Cooldown ends
        });
      } else {
        setState(() {
          remainingCooldownTime =
              remainingCooldownTime! - 1; // Decrement cooldown time
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrangeAccent,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.message,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
              ),
            ),
          ),
          TextButton(
            onPressed: remainingCooldownTime == null
                ? () {
                    widget.onButtonPressed();
                    startCooldown(); // Start cooldown after button press
                  }
                : null, // Disable the button during cooldown
            child: Text(
              remainingCooldownTime == null
                  ? widget.buttonText
                  : "${AppLocalizations.of(context)!.wait} ${remainingCooldownTime}s", // Show remaining time
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
