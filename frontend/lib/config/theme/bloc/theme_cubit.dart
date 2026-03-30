import 'package:flutter_bloc/flutter_bloc.dart';

enum AppThemeMode { light, dark, newspaper }

/// Holds the current AppThemeMode.
class ThemeState {
  final AppThemeMode themeMode;
  const ThemeState(this.themeMode);
}

/// Global Cubit that manages light / dark / newspaper theme.
/// Placed in config/theme/bloc/ so it is NOT coupled to any feature.
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(AppThemeMode.dark)); // default = dark

  void setTheme(AppThemeMode mode) {
    emit(ThemeState(mode));
  }

  void toggleTheme() {
    if (state.themeMode == AppThemeMode.dark) {
      setTheme(AppThemeMode.light);
    } else if (state.themeMode == AppThemeMode.light) {
      setTheme(AppThemeMode.newspaper);
    } else {
      setTheme(AppThemeMode.dark);
    }
  }

  bool get isDark => state.themeMode == AppThemeMode.dark;
  bool get isNewspaper => state.themeMode == AppThemeMode.newspaper;
}
