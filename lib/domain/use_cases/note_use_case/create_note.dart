import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/domain/entities/note.dart';
import 'package:note_app/domain/repository/auth_repository.dart';
import 'package:note_app/domain/repository/notes_repository.dart';

class CreateNoteUseCase {
  final NotesRepository repository;

  CreateNoteUseCase(this.repository);

  Future<Either<Failure, Note>> call({
    required String title,
    required String content,
    required String userId,
  }) {
    return repository.createNote(
      title: title,
      content: content,
      userId: userId,
    );
  }
}
