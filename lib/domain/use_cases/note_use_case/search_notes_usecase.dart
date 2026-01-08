import 'package:note_app/domain/entities/note.dart';

class SearchNotesUseCase {
  List<Note> call(List<Note> notes, String query) {
    if (query.isEmpty) {
      return notes;
    }

    final lowerQuery = query.toLowerCase();
    return notes.where((note) {
      return note.title.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
