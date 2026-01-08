import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/core/constants/app_colors.dart';
import 'package:note_app/core/constants/app_strings.dart';
import 'package:note_app/presentation/providers/auth_provider.dart';
import 'package:note_app/presentation/providers/notes_provider.dart';
import 'package:note_app/presentation/screens/auth/login_screen.dart';
import 'package:note_app/presentation/screens/notes/add_edit_notes_screen.dart';
import 'package:note_app/presentation/screens/notes/note_details_screen.dart';
import 'package:note_app/presentation/widgets/empty_widget.dart';
import 'package:note_app/presentation/widgets/loading_widget.dart';
import 'package:note_app/presentation/widgets/note_card.dart';

class NotesListScreen extends ConsumerStatefulWidget {
  const NotesListScreen({super.key});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void handleLogout() async {
    await ref.read(authViewModelProvider.notifier).logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
          return const Scaffold(body: CircularProgressIndicator());
        }

        final filteredNotes = ref.watch(filteredNotesProvider(user.id));

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: const Text(
              AppStrings.myNotes,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: AppColors.error),
                onPressed: handleLogout,
                tooltip: AppStrings.logout,
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.surface,
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                  decoration: InputDecoration(
                    hintText: AppStrings.searchNotes,
                    hintStyle: const TextStyle(color: AppColors.textTertiary),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon:
                        searchQuery.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                searchController.clear();
                                ref.read(searchQueryProvider.notifier).state =
                                    '';
                              },
                            )
                            : null,
                    filled: true,
                    fillColor: AppColors.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              Expanded(
                child:
                    filteredNotes.isEmpty
                        ? searchQuery.isNotEmpty
                            ? const EmptyStateWidget(
                              icon: Icons.search_off,
                              title: AppStrings.noNotesFound,
                              subtitle: AppStrings.tryDifferentSearch,
                            )
                            : const EmptyStateWidget(
                              icon: Icons.note_add_outlined,
                              title: AppStrings.noNotesYet,
                              subtitle: AppStrings.startCreatingNotes,
                            )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = filteredNotes[index];
                            return NoteCard(
                              note: note,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            NoteDetailScreen(note: note),
                                  ),
                                );
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditNoteScreen(userId: user.id),
                ),
              );
            },
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              AppStrings.addNote,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
      loading:
          () => const Scaffold(
            backgroundColor: AppColors.background,
            body: LoadingWidget(),
          ),
      error:
          (error, stack) => Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: Text('Error: $error')),
          ),
    );
  }
}
