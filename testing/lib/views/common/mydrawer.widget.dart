import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 32,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Procastinotes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: ref.watch(themeModeProvider) == ThemeMode.dark,
            onChanged: (value) {
              if (ref.watch(themeModeProvider) == ThemeMode.dark) {
                ref.read(themeModeProvider.notifier).state = ThemeMode.light;
              } else {
                ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_rounded),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsView(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(navigatorKey.currentContext!).pop();
                          await AuthService.instance.signOut();
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
