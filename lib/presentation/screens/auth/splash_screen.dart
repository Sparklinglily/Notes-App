import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/core/constants/app_colors.dart';
import 'package:note_app/core/constants/app_strings.dart';
import 'package:note_app/presentation/providers/auth_provider.dart';
import 'package:note_app/presentation/screens/auth/login_screen.dart';
import 'package:note_app/presentation/screens/notes/notes_list_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (previous, next) {
      next.whenData((user) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder:
                    (context) =>
                        user != null
                            ? const NotesListScreen()
                            : const LoginScreen(),
              ),
            );
          }
        });
      });
    });

    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_alt_outlined, size: 80, color: AppColors.primary),
            SizedBox(height: 24),
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 32),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
