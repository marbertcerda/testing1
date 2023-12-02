import 'package:flutter/material.dart';
import 'package:testing/exports.dart';
import 'package:testing/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: Procastinotes(),
    ),
  );
}

class Procastinotes extends ConsumerWidget {
  const Procastinotes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flexScheme = ref.watch(flexSchemeProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: flexScheme,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurfacesVariantDialog,
        blendLevel: 1,
        subThemesData: subThemeDataLight,
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
          keepPrimary: true,
        ),
        tones: FlexTones.jolly(Brightness.light),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
      ),
      themeMode: themeMode,
      darkTheme: FlexThemeData.dark(
        scheme: flexScheme,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurfacesVariantDialog,
        blendLevel: 2,
        subThemesData: subThemeDataDark,
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
        ),
        tones: FlexTones.chroma(Brightness.dark),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
      ),
      home: const AuthStateWrapper(),
    );
  }
}
