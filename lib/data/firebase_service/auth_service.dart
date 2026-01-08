import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app/data/models/user_model.dart';

abstract class FirebaseAuthService {
  Future<UserModel> signUp({required String email, required String password});
  Future<UserModel> login({required String email, required String password});
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class FirebaseAuthServiceImpl implements FirebaseAuthService {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthServiceImpl(this.firebaseAuth);

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Sign up failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Login failed');
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }

  String handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'too-many-requests':
        return 'Too many requests. Please try again later';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      default:
        return e.message ?? 'An authentication error occurred';
    }
  }
}
