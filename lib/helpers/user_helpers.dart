import 'package:firebase_auth/firebase_auth.dart';

/// Pemanggilan atau mengambil data User yang sudah login
class UserHelpers {
  static String? getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.email ?? '';
  }

  static String? getUserDisplayName() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? '';
  }

  static String? getUserPhotoURL() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.photoURL ?? '';
  }
}
