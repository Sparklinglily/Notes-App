import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/data/firebase_service/notes_service.dart';
import 'package:note_app/data/repository_impl/notes_repository_impl.dart';
import 'package:note_app/domain/entities/note.dart';

import 'package:note_app/domain/use_cases/note_use_case/create_note.dart';
import 'package:note_app/domain/use_cases/note_use_case/delete_note.dart';
import 'package:note_app/domain/use_cases/note_use_case/get_notes.dart';
import 'package:note_app/domain/use_cases/note_use_case/search_notes_usecace.dart';
import 'package:note_app/domain/use_cases/note_use_case/update_note.dart';
import 'package:riverpod/legacy.dart';

import 'package:uuid/uuid.dart';

// Providers for dependencies
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final uuidProvider = Provider<Uuid>((ref) {
  return const Uuid();
});

final firebaseNotesDataSourceProvider = Provider<FirebaseNotesService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final uuid = ref.watch(uuidProvider);
  return FirebaseNotesDataSourceImpl(firestore, uuid);
});

final notesRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(firebaseNotesDataSourceProvider);
  return NotesRepositoryImpl(dataSource);
});

// Use cases
final getNotesUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notesRepositoryProvider);
  return GetNotesUseCase(repository);
});

final createNoteUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notesRepositoryProvider);
  return CreateNoteUseCase(repository);
});

final updateNoteUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notesRepositoryProvider);
  return UpdateNoteUseCase(repository);
});

final deleteNoteUseCaseProvider = Provider((ref) {
  final repository = ref.watch(notesRepositoryProvider);
  return DeleteNoteUseCase(repository);
});

final searchNotesUseCaseProvider = Provider((ref) {
  return SearchNotesUseCase();
});

// Notes stream provider
final notesStreamProvider = StreamProvider.family<List<Note>, String>((
  ref,
  userId,
) {
  final useCase = ref.watch(getNotesUseCaseProvider);
  return useCase(userId).map((either) {
    return either.fold((failure) => <Note>[], (notes) => notes);
  });
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered notes provider
final filteredNotesProvider = Provider.family<List<Note>, String>((
  ref,
  userId,
) {
  final notesAsync = ref.watch(notesStreamProvider(userId));
  final searchQuery = ref.watch(searchQueryProvider);
  final searchUseCase = ref.watch(searchNotesUseCaseProvider);

  return notesAsync.when(
    data: (notes) => searchUseCase(notes, searchQuery),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Notes view model state
class NotesState {
  final bool isLoading;
  final String? error;
  final String? successMessage;

  NotesState({this.isLoading = false, this.error, this.successMessage});

  NotesState copyWith({
    bool? isLoading,
    String? error,
    String? successMessage,
  }) {
    return NotesState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

// Notes view model
class NotesViewModel extends StateNotifier<NotesState> {
  final CreateNoteUseCase _createNoteUseCase;
  final UpdateNoteUseCase _updateNoteUseCase;
  final DeleteNoteUseCase _deleteNoteUseCase;

  NotesViewModel(
    this._createNoteUseCase,
    this._updateNoteUseCase,
    this._deleteNoteUseCase,
  ) : super(NotesState());

  Future<bool> createNote({
    required String title,
    required String content,
    required String userId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _createNoteUseCase(
      title: title,
      content: content,
      userId: userId,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (note) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Note created successfully',
        );
        return true;
      },
    );
  }

  Future<bool> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _updateNoteUseCase(
      id: id,
      title: title,
      content: content,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (note) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Note updated successfully',
        );
        return true;
      },
    );
  }

  Future<bool> deleteNote(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _deleteNoteUseCase(id);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Note deleted successfully',
        );
        return true;
      },
    );
  }

  void clearMessages() {
    state = state.copyWith(error: null, successMessage: null);
  }
}

final notesViewModelProvider =
    StateNotifierProvider<NotesViewModel, NotesState>((ref) {
      return NotesViewModel(
        ref.watch(createNoteUseCaseProvider),
        ref.watch(updateNoteUseCaseProvider),
        ref.watch(deleteNoteUseCaseProvider),
      );
    });
