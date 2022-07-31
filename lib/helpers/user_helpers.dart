import 'package:firebase_auth/firebase_auth.dart';

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
