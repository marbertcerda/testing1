import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _emailError = null;
        _passwordError = null;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _emailError = null;
        _passwordError = null;
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
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 32,
                    ),
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
                  'Welcome back!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w100,
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                const Text(
                  'Login to your account',
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
                    if (value!.isEmpty) {
                      return 'Enter your email address';
                    }

                    return _emailError;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  obscureText: _obscurePassword,
                  controller: _passwordController,
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
                    if (value!.isEmpty) {
                      return 'Enter your password';
                    }

                    return _passwordError;
                  },
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _login,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text('Login'),
                ),
                const SizedBox(height: 12),
                Container(
                  alignment: Alignment.center,
                  child: const TextButton(
                    onPressed: goToRegister,
                    child: Text('Create an account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      try {
        setState(() {
          _isLoading = true;
        });
        await AuthService.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (e.code == 'invalid-credential') {
          setState(() {
            _emailError = 'Incorrect email or password';
            _passwordError = 'Incorrect email or password';
          });
        }

        _formKey.currentState!.validate();
      }
    }
  }
}
