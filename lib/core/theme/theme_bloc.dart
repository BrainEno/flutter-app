import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'theme_preference.dart';
import 'package:belog/init_dependencies.dart';

class ThemeState {
  final ThemeMode themeMode;
  ThemeState(this.themeMode);
}

abstract class ThemeEvent {}

// Fired once, immediately after the Bloc is constructed,
// to load the saved theme from Isar.
class InitializeTheme extends ThemeEvent {}

// Fired whenever the user wants to toggle between light/dark.
class ToggleTheme extends ThemeEvent {}

// --- Bloc ---------------------------------------------------------

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(ThemeMode.dark)) {
    // Register handlers
    on<InitializeTheme>(_onInitializeTheme);
    on<ToggleTheme>(_onToggleTheme);

    // Kick off loading the persisted theme
    add(InitializeTheme());
  }

  Future<void> _onInitializeTheme(
    InitializeTheme event,
    Emitter<ThemeState> emit,
  ) async {
    // Retrieve the saved theme from Isar
    final themePref = await isar.themePreferences.where().findFirst();
    if (themePref != null) {
      emit(ThemeState(themePref.themeMode));
    } else {
      // No saved preference: default to dark and persist it
      await isar.writeTxn(() async {
        await isar.themePreferences
            .put(ThemePreference(themeMode: ThemeMode.dark));
      });
      emit(ThemeState(ThemeMode.dark));
    }
  }

  Future<void> _onToggleTheme(
    ToggleTheme event,
    Emitter<ThemeState> emit,
  ) async {
    // Compute the new theme
    final newThemeMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Persist it
    await isar.writeTxn(() async {
      await isar.themePreferences.put(ThemePreference(themeMode: newThemeMode));
    });

    // Emit the updated theme
    emit(ThemeState(newThemeMode));
  }
}
