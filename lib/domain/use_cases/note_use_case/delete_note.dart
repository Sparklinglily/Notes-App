import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/domain/repository/auth_repository.dart';
import 'package:note_app/domain/repository/notes_repository.dart';

class DeleteNoteUseCase {
  final NotesRepository repository;

  DeleteNoteUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteNote(id);
  }
}
