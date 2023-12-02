import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

final flexSchemeProvider = StateProvider<FlexScheme>((ref) {
  return FlexScheme.aquaBlue;
});

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.dark;
});
