import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/domain/entities/user.dart' show User;

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User?>> getCurrentUser();

  Stream<User?> get authStateChanges;
}

// Either implementation for error handling
class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool isLeft;

  const Either.left(L left) : _left = left, _right = null, isLeft = true;

  const Either.right(R right) : _left = null, _right = right, isLeft = false;

  bool get isRight => !isLeft;

  L get left {
    if (isLeft) return _left!;
    throw Exception('Called left on Right');
  }

  R get right {
    if (isRight) return _right!;
    throw Exception('Called right on Left');
  }

  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) {
    if (isLeft) {
      return leftFn(_left as L);
    } else {
      return rightFn(_right as R);
    }
  }
}
