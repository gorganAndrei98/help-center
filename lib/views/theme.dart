import 'dart:io';

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {

  static ThemeData _createFromColorScheme(ColorScheme colorScheme) {
    assert(colorScheme != null);

    ThemeData data = ThemeData(
      fontFamily: Platform.isIOS ? "SFProDisplay" : null,
      colorScheme: colorScheme.copyWith(brightness: Brightness.light),
      dividerColor: AppColors.DIVIDER_COLOR,
    );

    final tabBarTheme = data.tabBarTheme;
    final appBarTheme = data.appBarTheme;
    final newIndicator = UnderlineTabIndicator(
      borderSide: BorderSide(
          width: 2,
          color: appBarTheme.foregroundColor ??
              colorScheme.onPrimary ??
              Colors.white),
    );
    data = data.copyWith(
        tabBarTheme: tabBarTheme.copyWith(indicator: newIndicator));

    return data;
  }

  static ThemeData _create(MaterialColor primarySwatch,
      {Color? primary, Color? primaryVariant, Color? secondary}) {
    assert(primarySwatch != null);

    return _createFromColorScheme(
      ColorScheme.fromSwatch(primarySwatch: primarySwatch).copyWith(
        primary: primary,
        //primaryVariant: primaryVariant,
        secondary: secondary,
      ),
    );
  }

  static final base = _create(
    AppColors.BASE_SWATCH,
    primary: AppColors.BASE_INDIGO_DARK,
    primaryVariant: AppColors.BASE_INDIGO_DARKER,
    secondary: AppColors.BASE_SWATCH.shade700,
  );
}