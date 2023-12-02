import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  bool _isLoading = false;
  String? emailError;
  String? passwordError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        emailError = null;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        passwordError = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      if (themeMode == ThemeMode.dark) {
                        ref.read(themeModeProvider.notifier).state =
                            ThemeMode.light;
                        return;
                      } else if (themeMode == ThemeMode.light) {
                        ref.read(themeModeProvider.notifier).state =
                            ThemeMode.system;
                        return;
                      } else {
                        ref.read(themeModeProvider.notifier).state =
                            ThemeMode.dark;
                        return;
                      }
                    },
                    icon: Icon(
                      themeMode == ThemeMode.dark
                          ? Icons.light_mode_rounded
                          : themeMode == ThemeMode.light
                              ? Icons.phone_iphone_rounded
                              : Icons.dark_mode_rounded,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded),
                    SizedBox(width: 12),
                    Text(
                      'Procastinote',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Are you procastinoting too?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                const Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.person_2_rounded),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return emailError;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_rounded),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter your password';
                    }

                    return passwordError;
                  },
                ),
                const SizedBox(height: 12),
                FilledButton(
                    onPressed: _createAccount,
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Create account')),
                const SizedBox(height: 12),
                Container(
                  alignment: Alignment.center,
                  child: const TextButton(
                    onPressed: goToLogin,
                    child: Text('I already have an account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createAccount() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        setState(() {
          _isLoading = true;
        });
        await AuthService.instance.signUpWithEmailAndPassword(
          email: email,
          password: password,
        );

        Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const AuthStateWrapper(),
          ),
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });

        if (e.code == "invalid-email") {
          setState(() {
            emailError = "Invalid email";
          });
        } else if (e.code == "email-already-in-use") {
          setState(() {
            emailError = "Email already in use";
          });
        } else if (e.code == "weak-password") {
          setState(() {
            passwordError = "Password is too weak";
          });
        } else {
          setState(() {
            emailError = null;
            passwordError = null;
          });
        }

        setState(() {
          _isLoading = false;
        });
        _formKey.currentState!.validate();
      }
    }
  }
}
