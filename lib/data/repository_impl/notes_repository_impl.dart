import 'package:note_app/core/errors/failures.dart';
import 'package:note_app/data/firebase_service/notes_service.dart';
import 'package:note_app/domain/entities/note.dart';
import 'package:note_app/domain/repository/auth_repository.dart';
import 'package:note_app/domain/repository/notes_repository.dart';

class NotesRepositoryImpl implements NotesRepository {
  final FirebaseNotesService fbNoteService;

  NotesRepositoryImpl(this.fbNoteService);

  @override
  Stream<Either<Failure, List<Note>>> getNotes(String userId) {
    try {
      return fbNoteService
          .getNotes(userId)
          .map((noteModels) {
            final notes = noteModels.map((model) => model.toEntity()).toList();
            return Either<Failure, List<Note>>.right(notes);
          })
          .handleError((error) {
            return Either<Failure, List<Note>>.left(
              ServerFailure(error.toString()),
            );
          });
    } catch (e) {
      return Stream.value(Either.left(ServerFailure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote({
    required String title,
    required String content,
    required String userId,
  }) async {
    try {
      final noteModel = await fbNoteService.createNote(
        title: title,
        content: content,
        userId: userId,
      );
      return Either.right(noteModel.toEntity());
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    try {
      final noteModel = await fbNoteService.updateNote(
        id: id,
        title: title,
        content: content,
      );
      return Either.right(noteModel.toEntity());
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    try {
      await fbNoteService.deleteNote(id);
      return const Either.right(null);
    } catch (e) {
      return Either.left(ServerFailure(e.toString()));
    }
  }
}
