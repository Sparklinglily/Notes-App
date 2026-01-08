import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:note_app/core/constants/app_colors.dart';
import 'package:note_app/core/constants/app_strings.dart';
import 'package:note_app/domain/entities/note.dart';
import 'package:note_app/presentation/providers/notes_provider.dart';
import 'package:note_app/presentation/screens/notes/add_edit_notes_screen.dart';

class NoteDetailScreen extends ConsumerWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  void showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.deleteNote),
          content: const Text(AppStrings.deleteNoteConfirm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                AppStrings.cancel,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final success = await ref
                    .read(notesViewModelProvider.notifier)
                    .deleteNote(note.id);

                if (context.mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(AppStrings.noteDeleted),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    Navigator.of(context).pop();
                  } else {
                    final error = ref.read(notesViewModelProvider).error;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(error ?? AppStrings.somethingWentWrong),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                AppStrings.delete,
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) =>
                          AddEditNoteScreen(userId: note.userId, note: note),
                ),
              );
            },
            tooltip: AppStrings.edit,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.error),
            onPressed: () => showDeleteDialog(context, ref),
            tooltip: AppStrings.delete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Updated ${dateFormat.format(note.updatedAt)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  note.content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Created ${dateFormat.format(note.createdAt)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
