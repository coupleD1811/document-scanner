import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'auth_failure.dart';
import 'auth_repository.dart';
import 'auth_user.dart';

class FirebaseAuthRepository implements AuthRepository {
  const FirebaseAuthRepository({
    required firebase_auth.FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  @override
  Stream<AuthUser?> get user =>
      _firebaseAuth.userChanges().map(_mapFirebaseUser);

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    } on Object {
      throw const AuthFailure(AuthFailureCode.signInFailed);
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    } on Object {
      throw const AuthFailure(AuthFailureCode.accountCreationFailed);
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    } on Object {
      throw const AuthFailure(AuthFailureCode.passwordResetFailed);
    }
  }

  @override
  Future<String?> currentIdToken({bool forceRefresh = false}) {
    return _firebaseAuth.currentUser?.getIdToken(forceRefresh) ??
        Future<String?>.value();
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on firebase_auth.FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    } on Object {
      throw const AuthFailure(AuthFailureCode.signOutFailed);
    }
  }
}

AuthUser? _mapFirebaseUser(firebase_auth.User? user) {
  if (user == null) {
    return null;
  }

  return AuthUser(
    id: user.uid,
    email: user.email,
    displayName: user.displayName,
    photoUrl: user.photoURL,
    isEmailVerified: user.emailVerified,
  );
}

AuthFailure _mapFirebaseAuthException(
  firebase_auth.FirebaseAuthException error,
) {
  return switch (error.code) {
    'invalid-email' => const AuthFailure(AuthFailureCode.invalidEmail),
    'invalid-credential' ||
    'user-not-found' ||
    'wrong-password' => const AuthFailure(AuthFailureCode.incorrectCredentials),
    'email-already-in-use' => const AuthFailure(
      AuthFailureCode.emailAlreadyInUse,
    ),
    'weak-password' => const AuthFailure(AuthFailureCode.weakPassword),
    'user-disabled' => const AuthFailure(AuthFailureCode.userDisabled),
    'operation-not-allowed' => const AuthFailure(
      AuthFailureCode.emailPasswordNotEnabled,
    ),
    'too-many-requests' => const AuthFailure(AuthFailureCode.tooManyRequests),
    'network-request-failed' => const AuthFailure(
      AuthFailureCode.networkRequestFailed,
    ),
    _ => const AuthFailure(AuthFailureCode.authenticationFailed),
  };
}
