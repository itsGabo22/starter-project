import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the current ThemeMode.
class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

/// Global Cubit that manages light / dark theme.
/// Placed in config/theme/bloc/ so it is NOT coupled to any feature.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.dark)); // default = dark

  void toggleTheme() {
    final next = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    emit(ThemeState(next));
  }

  bool get isDark => state.themeMode == ThemeMode.dark;
}
