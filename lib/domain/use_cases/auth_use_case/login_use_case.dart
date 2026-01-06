import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/domain/entities/user.dart';
import 'package:note_app/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
