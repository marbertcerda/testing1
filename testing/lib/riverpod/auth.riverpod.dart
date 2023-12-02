import 'package:testing/exports.dart';

final authProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

final userStreamProvider = StreamProvider<User?>((ref) {
  return ref.watch(authProvider).userStream;
});
