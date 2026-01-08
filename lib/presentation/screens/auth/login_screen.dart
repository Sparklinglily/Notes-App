import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/core/constants/app_colors.dart';
import 'package:note_app/core/constants/app_strings.dart';
import 'package:note_app/core/constants/utils/validators.dart';
import 'package:note_app/presentation/providers/auth_provider.dart';
import 'package:note_app/presentation/screens/auth/sign_up.dart';
import 'package:note_app/presentation/screens/notes/notes_list_screen.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final loginFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isNavigating = false;

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  // Future<void> handleLogin() async {
  //   if (isNavigating) return;
  //   // Clear any former errors
  //   ref.read(authViewModelProvider.notifier).clearError();

  //   if (loginFormKey.currentState!.validate()) {
  //     final success = await ref
  //         .read(authViewModelProvider.notifier)
  //         .login(
  //           loginEmailController.text.trim(),
  //           loginPasswordController.text,
  //         );

  //     if (mounted && !isNavigating) {
  //       if (success) {
  //         isNavigating = true;
  //         // Navigate to notes list screen u success
  //         Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => const NotesListScreen()),
  //         );
  //       } else {
  //         // Show error message
  //         final error = ref.read(authViewModelProvider).error;
  //         if (error != null) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text(error),
  //               backgroundColor: AppColors.error,
  //               behavior: SnackBarBehavior.floating,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8),
  //               ),
  //             ),
  //           );
  //         }
  //       }
  //     }
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   final authState = ref.watch(authViewModelProvider);
  Future<void> handleLogin() async {
    ref.read(authViewModelProvider.notifier).clearError();

    if (loginFormKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .login(
            loginEmailController.text.trim(),
            loginPasswordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authViewModelProvider.select((s) => s.isLoading),
    );

    // Listen for errors
    ref.listen(authViewModelProvider.select((s) => s.error), (previous, error) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    });

    // Listen for successful login (user will no longer be null)
    ref.listen(authStateProvider, (previous, next) {
      next.whenData((user) {
        if (user != null && mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const NotesListScreen()),
          );
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.note_alt_outlined,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    AppStrings.welcomeBack,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.loginToContinue,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  CustomTextField(
                    controller: loginEmailController,
                    label: AppStrings.email,
                    hint: AppStrings.enterEmail,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: loginPasswordController,
                    label: AppStrings.password,
                    hint: AppStrings.enterPassword,
                    obscureText: isPasswordVisible,
                    validator: Validators.validatePassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: isLoading ? null : handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: AppColors.primary.withOpacity(
                        0.6,
                      ),
                    ),
                    child:
                        isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text(
                              AppStrings.login,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.dontHaveAccount,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const SignupScreen(),
                                    ),
                                  );
                                },
                        child: const Text(
                          AppStrings.signup,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
