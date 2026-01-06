import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/domain/entities/note.dart';
import 'package:note_app/domain/repository/auth_repository.dart';
import 'package:note_app/domain/repository/notes_repository.dart';

class GetNotesUseCase {
  final NotesRepository repository;

  GetNotesUseCase(this.repository);

  Stream<Either<Failure, List<Note>>> call(String userId) {
    return repository.getNotes(userId);
  }
}
