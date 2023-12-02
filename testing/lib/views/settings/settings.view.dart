import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

final userChangesStream = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.userChanges();
});

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SettingsViewState();
}

class SettingsViewState extends ConsumerState<SettingsView> {
  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Account',
              style: Theme.of(context).textTheme.copyWith().bodyLarge,
            ),
            ref.watch(userChangesStream).when(
                  data: (user) {
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text(
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                      trailing: const Icon(Icons.edit),
                      subtitle: Text(user!.displayName!),
                      onTap: _showNameEditFormDialog,
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, s) => const Center(
                    child: Text('Error loading user'),
                  ),
                ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(currentUser!.email!),
            ),
            const SizedBox(height: 20),
            Text(
              'Security',
              style: Theme.of(context).textTheme.copyWith().bodyLarge,
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text(
                'Change Password',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
              trailing: const Icon(Icons.edit),
              onTap: _showPasswordEditFormDialog,
            ),
            const SizedBox(height: 20),
            Text(
              'Theme',
              style: Theme.of(context).textTheme.copyWith().bodyLarge,
            ),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text(
                'Change Theme',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                ),
              ),
              trailing: const Icon(Icons.edit),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      insetPadding: EdgeInsets.zero,
                      child: Container(
                        width: 200,
                        height: MediaQuery.of(context).size.height * 0.75,
                        padding: const EdgeInsets.all(16),
                        child: ListView.builder(
                          itemCount: FlexScheme.values.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                FlexScheme.values[index].name.capitalize,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              onTap: () {
                                ref.read(flexSchemeProvider.notifier).state =
                                    FlexScheme.values[index];
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNameEditFormDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final currentUser = AuthService.instance.currentUser;
        return Dialog(
          child: NameEditForm(
            name: currentUser!.displayName!,
          ),
        );
      },
    );
  }

  void _showPasswordEditFormDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          child: PasswordEditFormDialog(),
        );
      },
    );
  }
}

class NameEditForm extends StatefulWidget {
  const NameEditForm({
    super.key,
    required this.name,
  });

  final String name;

  @override
  State<NameEditForm> createState() => _NameEditFormState();
}

class _NameEditFormState extends State<NameEditForm> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Edit Name',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  setState(() {
                    _isLoading = true;
                  });
                  await AuthService.instance.updateName(_emailController.text);
                  ScaffoldMessenger.of(navigatorKey.currentContext!)
                      .showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Name updated successfully'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(navigatorKey.currentContext!)
                      .showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'There was an error updating your name',
                      ),
                    ),
                  );
                }

                setState(() {
                  _isLoading = false;
                });

                Navigator.of(navigatorKey.currentContext!).pop();
              }
            },
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Save'),
          ),
          const SizedBox(
            height: 12,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(navigatorKey.currentContext!).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class PasswordEditFormDialog extends StatefulWidget {
  const PasswordEditFormDialog({
    super.key,
  });

  @override
  State<PasswordEditFormDialog> createState() => _PasswordEditFormDialogState();
}

class _PasswordEditFormDialogState extends State<PasswordEditFormDialog> {
  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Edit Name',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  obscureText: _obscurePassword,
                  controller: _oldPassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        )),
                    labelText: 'Old Password',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your old password';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: _obscurePassword,
                  controller: _newPassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        )),
                    labelText: 'New Password',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: _obscurePassword,
                  controller: _confirmPassword,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        )),
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }

                    if (value != _newPassword.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  setState(() {
                    _isLoading = true;
                  });
                  await AuthService.instance.updatePassword(
                    _oldPassword.text,
                    _newPassword.text,
                  );
                  ScaffoldMessenger.of(navigatorKey.currentContext!)
                      .showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Password updated successfully'),
                    ),
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'invalid-credential') {
                    ScaffoldMessenger.of(navigatorKey.currentContext!)
                        .showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Invalid password',
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(navigatorKey.currentContext!)
                        .showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'There was an error updating your password',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(navigatorKey.currentContext!)
                      .showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(
                        'There was an error updating your password',
                      ),
                    ),
                  );
                }

                setState(() {
                  _isLoading = false;
                });

                Navigator.of(navigatorKey.currentContext!).pop();
              }
            },
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Update Password'),
          ),
          const SizedBox(
            height: 12,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(navigatorKey.currentContext!).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
