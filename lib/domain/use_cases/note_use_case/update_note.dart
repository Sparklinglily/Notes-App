import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/domain/entities/note.dart';
import 'package:note_app/domain/repository/auth_repository.dart';
import 'package:note_app/domain/repository/notes_repository.dart';

class UpdateNoteUseCase {
  final NotesRepository repository;

  UpdateNoteUseCase(this.repository);

  Future<Either<Failure, Note>> call({
    required String id,
    required String title,
    required String content,
  }) {
    return repository.updateNote(id: id, title: title, content: content);
  }
}
