import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/core/constants/app_colors.dart';
import 'package:note_app/core/constants/app_strings.dart';
import 'package:note_app/core/constants/utils/validators.dart';
import 'package:note_app/domain/entities/note.dart';
import 'package:note_app/presentation/providers/notes_provider.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';

class AddEditNoteScreen extends ConsumerStatefulWidget {
  final String userId;
  final Note? note;

  const AddEditNoteScreen({super.key, required this.userId, this.note});

  @override
  ConsumerState<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends ConsumerState<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController contentController;

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(notesViewModelProvider.notifier);

      final bool success;
      if (isEditing) {
        success = await notifier.updateNote(
          id: widget.note!.id,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
        );
      } else {
        success = await notifier.createNote(
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          userId: widget.userId,
        );
      }

      if (mounted) {
        if (success) {
          final message =
              isEditing ? AppStrings.noteUpdated : AppStrings.noteCreated;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(notesViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isEditing ? AppStrings.editNote : AppStrings.addNote,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: notesState.isLoading ? null : _handleSave,
            child:
                notesState.isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                      ),
                    )
                    : const Text(
                      AppStrings.save,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            CustomTextField(
              controller: titleController,
              label: AppStrings.noteTitle,
              hint: 'Enter note title',
              validator: Validators.validateTitle,
              prefixIcon: const Icon(Icons.title),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: contentController,
              label: AppStrings.noteContent,
              hint: 'Enter note content',
              maxLines: 15,
              validator: Validators.validateContent,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(bottom: 180),
                child: Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 32),
            if (isEditing) ...[
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
                        'Last updated: ${_formatDate(widget.note!.updatedAt)}',
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
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
