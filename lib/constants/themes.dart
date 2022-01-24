import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pets_weight_graph/constants/colors.dart';

final setLightTheme = _buildLightTheme();
final setDarkTheme = _buildDarkTheme();

ThemeData _buildLightTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.white,
        background: Colors.white,
        secondary: AppColors.BLACK,
        brightness: Brightness.light),
  );
}

ThemeData _buildDarkTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.BLACK,
        background: AppColors.BLACK,
        secondary: Colors.white,
        brightness: Brightness.dark),
  );
}
