import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

class AuthStateWrapper extends ConsumerWidget {
  const AuthStateWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      curve: Curves.easeInOut,
      child: ref.watch(userStreamProvider).when(
            data: (user) {
              if (user == null) {
                return const LoginView();
              }

              if (user.displayName == null || user.displayName!.isEmpty) {
                return const AddNameView();
              }

              return const HomeView();
            },
            loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, stack) => Scaffold(
              body: Center(
                child: Text('Error: $err'),
              ),
            ),
          ),
    );
  }
}
