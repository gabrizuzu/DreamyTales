import 'dart:ui';

import 'package:dreamy_tales/utils/colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppColors Test', () {
    expect(AppColors.textColor1, equals(const Color(0xFF989acd)));
    expect(AppColors.textColor2, equals(const Color(0xFF878593)));
    expect(AppColors.bigTextColor, equals(const Color(0xFF2e2e31)));
    expect(AppColors.mainColor, equals(const Color(0xFF5d69b3)));
    expect(AppColors.starColor, equals(const Color(0xFFe7bb4e)));
    expect(AppColors.mainTextColor, equals(const Color(0xFFababad)));
    expect(AppColors.buttonBackground, equals(const Color(0xFFf1f1f9)));
  });
}
