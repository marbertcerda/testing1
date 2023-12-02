import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

class AddNameView extends ConsumerStatefulWidget {
  const AddNameView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNameViewState();
}

class _AddNameViewState extends ConsumerState<AddNameView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
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
              const SizedBox(height: 24),
              const Text(
                "Welcome to Procastinote!\nLet's get started!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w200,
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'How should we call you?',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await AuthService.instance.updateName(
                        _nameController.text,
                      );
                      setState(() {
                        _isLoading = false;
                      });

                      await showDialog(
                        context: navigatorKey.currentContext!,
                        builder: (context) => AlertDialog(
                          contentTextStyle: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w300,
                            fontSize: 18,
                          ),
                          titleTextStyle: const TextStyle(
                            fontSize: 24,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          title: const Text('Success!'),
                          content: const Text(
                            "That's great! You can now start using Procastinote!",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );

                      ref.invalidate(userStreamProvider);

                      Navigator.of(navigatorKey.currentContext!)
                          .pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AuthStateWrapper(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(navigatorKey.currentContext!)
                          .showSnackBar(
                        const SnackBar(
                          content: Text('Something went wrong!'),
                        ),
                      );
                      await AuthService.instance.signOut();
                    }
                  }
                },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
