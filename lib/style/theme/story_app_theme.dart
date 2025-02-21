import 'package:flutter/material.dart';
import 'package:story_app/style/colors/story_app_colors.dart';
import '../typography/story_app_text_styles.dart';

class StoryAppTheme{
  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: StoryAppTextStyles.displayLarge,
      displayMedium: StoryAppTextStyles.displayMedium,
      displaySmall: StoryAppTextStyles.displaySmall,
      headlineLarge: StoryAppTextStyles.headlineLarge,
      headlineMedium: StoryAppTextStyles.headlineMedium,
      headlineSmall: StoryAppTextStyles.headlineSmall,
      titleLarge: StoryAppTextStyles.titleLarge,
      titleMedium: StoryAppTextStyles.titleMedium,
      titleSmall: StoryAppTextStyles.titleSmall,
      bodyLarge: StoryAppTextStyles.bodyLargeBold,
      bodyMedium: StoryAppTextStyles.bodyLargeMedium,
      bodySmall: StoryAppTextStyles.bodyLargeRegular,
      labelLarge: StoryAppTextStyles.labelLarge,
      labelMedium: StoryAppTextStyles.labelMedium,
      labelSmall: StoryAppTextStyles.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: StoryAppColors.red.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: StoryAppColors.pink.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme
    );
  }
}