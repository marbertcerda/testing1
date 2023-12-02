import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void goToLogin() {
  Navigator.of(navigatorKey.currentContext!).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return const LoginView();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}

void goToRegister() {
  Navigator.of(navigatorKey.currentContext!).pushReplacement(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return const RegisterView();
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}

void goToNoteView(Note note) {
  Navigator.of(navigatorKey.currentContext!).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CreateNoteView(
          note: note,
          mode: NoteMode.view,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    ),
  );
}
