import 'package:flutter/material.dart';
import '../theme/gradients.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final String variant;
  final Color color;
  final bool disabled;
  final VoidCallback onTap;

  const GradientButton({
    Key? key,
    required this.text,
    required this.variant,
    required this.color,
    this.disabled = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        decoration: gradientStyles(variant, color, disabled: disabled),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: disabled ? Colors.white54 : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration gradientStyles(String variant, Color color,
      {bool disabled = false}) {
    final Map<String, Gradient> gradients = {
      "red": AppGradients.red,
      "blueGradient": AppGradients.blueGradient,
      "primary": AppGradients.primary,
      "card": AppGradients.card,
    };

    Gradient backgroundGradient =
        gradients[variant] ?? AppGradients.blueGradient;
    if (disabled) {
      backgroundGradient = AppGradients.disabled;
    }

    return BoxDecoration(
      gradient: backgroundGradient,
      borderRadius: BorderRadius.circular(12),
    );
  }
}
