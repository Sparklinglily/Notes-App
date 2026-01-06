import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/domain/entities/user.dart';
import 'package:note_app/domain/repository/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, User?>> call() {
    return repository.getCurrentUser();
  }

  Stream<User?> get authStateChanges => repository.authStateChanges;
}
