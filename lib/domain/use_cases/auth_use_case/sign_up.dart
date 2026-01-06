import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/domain/entities/user.dart';
import 'package:note_app/domain/repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String password,
  }) {
    return repository.signUp(email: email, password: password);
  }
}
