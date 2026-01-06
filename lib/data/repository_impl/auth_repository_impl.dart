import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/data/firebase_service/auth_service.dart';
import 'package:note_app/domain/entities/user.dart';
import 'package:note_app/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await dataSource.signUp(
        email: email,
        password: password,
      );
      return Either.right(userModel.toEntity());
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await dataSource.login(
        email: email,
        password: password,
      );
      return Either.right(userModel.toEntity());
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      return const Either.right(null);
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final userModel = await dataSource.getCurrentUser();
      return Either.right(userModel?.toEntity());
    } catch (e) {
      return Either.left(AuthFailure(e.toString()));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return dataSource.authStateChanges.map((userModel) {
      return userModel?.toEntity();
    });
  }
}
