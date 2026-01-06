import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/domain/entities/note.dart';
import 'package:note_app/domain/repository/auth_repository.dart';

abstract class NotesRepository {
  Stream<Either<Failure, List<Note>>> getNotes(String userId);

  Future<Either<Failure, Note>> createNote({
    required String title,
    required String content,
    required String userId,
  });

  Future<Either<Failure, Note>> updateNote({
    required String id,
    required String title,
    required String content,
  });

  Future<Either<Failure, void>> deleteNote(String id);
}
