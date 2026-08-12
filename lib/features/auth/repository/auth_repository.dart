import 'auth_user.dart';

abstract interface class AuthRepository {
  Stream<AuthUser?> get user;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> sendPasswordResetEmail({required String email});

  Future<String?> currentIdToken({bool forceRefresh = false});

  Future<void> signOut();
}
