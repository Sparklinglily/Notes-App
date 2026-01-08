import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/data/models/note_model.dart';

import 'package:uuid/uuid.dart';

abstract class FirebaseNotesService {
  Stream<List<NoteModel>> getNotes(String userId);
  Future<NoteModel> createNote({
    required String title,
    required String content,
    required String userId,
  });
  Future<NoteModel> updateNote({
    required String id,
    required String title,
    required String content,
  });
  Future<void> deleteNote(String id);
}

class FirebaseNotesServiceImpl implements FirebaseNotesService {
  final FirebaseFirestore firestore;
  final Uuid uuid;

  FirebaseNotesServiceImpl(this.firestore, this.uuid);

  String get collection => 'notes';

  @override
  Stream<List<NoteModel>> getNotes(String userId) {
    try {
      return firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return NoteModel.fromFirestore(doc);
            }).toList();
          });
    } catch (e) {
      throw Exception('Failed to get notes: $e');
    }
  }

  @override
  Future<NoteModel> createNote({
    required String title,
    required String content,
    required String userId,
  }) async {
    try {
      final now = DateTime.now();
      final id = uuid.v4();

      final note = NoteModel(
        id: id,
        title: title,
        content: content,
        userId: userId,
        createdAt: now,
        updatedAt: now,
      );

      await firestore.collection(collection).doc(id).set(note.toFirestore());

      return note;
    } on FirebaseException catch (e) {
      throw Exception('Failed to create note: ${e.message}');
    }
  }

  @override
  Future<NoteModel> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    try {
      final docRef = firestore.collection(collection).doc(id);
      final doc = await docRef.get();

      if (!doc.exists) {
        throw Exception('Note not found');
      }

      final existingNote = NoteModel.fromFirestore(doc);
      final now = DateTime.now();

      final updatedNote = NoteModel(
        id: existingNote.id,
        title: title,
        content: content,
        userId: existingNote.userId,
        createdAt: existingNote.createdAt,
        updatedAt: now,
      );

      await docRef.update(updatedNote.toFirestore());

      return updatedNote;
    } on FirebaseException catch (e) {
      throw Exception('Failed to update note: ${e.message}');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await firestore.collection(collection).doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete note: ${e.message}');
    }
  }
}
