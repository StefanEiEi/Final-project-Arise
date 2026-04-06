import 'package:flutter/material.dart';

class AriseRank {
  static Color getColor(int level) {
    if (level >= 100) return const Color(0xFFB400FF); // SS+
    if (level >= 80) return const Color(0xFFFFD700); // S
    if (level >= 60) return const Color(0xFFFF4500); // A
    if (level >= 40) return const Color(0xFF8A2BE2); // B
    if (level >= 20) return const Color(0xFF007BFF); // C
    if (level >= 10) return const Color(0xFF00FC97); // D
    return const Color(0xFF7892B0); // E
  }

  static String getLabel(int level) {
    if (level >= 100) return 'RANK SS+';
    if (level >= 80) return 'RANK S';
    if (level >= 60) return 'RANK A';
    if (level >= 40) return 'RANK B';
    if (level >= 20) return 'RANK C';
    if (level >= 10) return 'RANK D';
    return 'RANK E';
  }
}
