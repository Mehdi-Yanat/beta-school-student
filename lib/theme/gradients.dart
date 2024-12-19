import 'package:flutter/material.dart';

class AppGradients {
  static const LinearGradient red = LinearGradient(
    colors: [Color(0xFFDE0B28), Color(0xFF0A0E23)],
    begin: Alignment(-0.97, -0.24),
    end: Alignment(0.97, 0.24),
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [
      Color(0xFF0075FF),
      Color(0xFF21D4FD),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient card = LinearGradient(
    colors: [
      Color.fromRGBO(6, 11, 40, 0.94),
      Color.fromRGBO(27, 26, 103, 1.0),
    ],
    stops: [0.1941, 0.7665], // Corresponding to 19.41% and 76.65%
    begin: Alignment(-0.9, 0.6), // Approximates 127.09 degrees
    end: Alignment(0.9, -0.6),
  );

  static const LinearGradient disabled = LinearGradient(
    colors: [
      Color.fromRGBO(128, 128, 128, 1),
      Color.fromRGBO(160, 160, 160, 1),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primary = LinearGradient(
    colors: [
      Color(0xFF4318ff), // main
      Color(0xFF9f7aea), // state
    ],
    begin: Alignment(-0.97, -0.24), // approximates degree 97.89
    end: Alignment(0.97, 0.24),
  );
}
