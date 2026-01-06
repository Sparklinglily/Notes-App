import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/core/constants/app_colors.dart';
import 'package:note_app/core/constants/app_strings.dart';
import 'package:note_app/core/constants/utils/validators.dart';
import 'package:note_app/presentation/providers/auth_provider.dart';
import 'package:note_app/presentation/screens/auth/login_screen.dart';
import 'package:note_app/presentation/screens/notes/notes_list_screen.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final signUpFormKey = GlobalKey<FormState>();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  bool isSignUpPasswordVisible = false;
  bool isSignUpNavigating = false;

  @override
  void dispose() {
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (isSignUpNavigating) return;
    // Clear any previous errors
    ref.read(authViewModelProvider.notifier).clearError();

    if (signUpFormKey.currentState!.validate()) {
      final success = await ref
          .read(authViewModelProvider.notifier)
          .signUp(
            signUpEmailController.text.trim(),
            signUpPasswordController.text,
          );

      if (mounted && !isSignUpNavigating) {
        if (success) {
          isSignUpNavigating = true;
          // Navigate to notes list on success
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const NotesListScreen()),
          );
        } else {
          // Show error message
          final error = ref.read(authViewModelProvider).error;
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
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: signUpFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.note_add_outlined,
                      size: 60,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Welcome Text
                  const Text(
                    AppStrings.createYourAccount,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.signupToContinue,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Email Field
                  CustomTextField(
                    controller: signUpEmailController,
                    label: AppStrings.email,
                    hint: AppStrings.enterEmail,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  CustomTextField(
                    controller: signUpPasswordController,
                    label: AppStrings.password,
                    hint: AppStrings.enterPasswordHint,
                    obscureText: isSignUpPasswordVisible,
                    validator: Validators.validatePassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isSignUpPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isSignUpPasswordVisible = !isSignUpPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Signup Button
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: AppColors.secondary.withOpacity(
                        0.6,
                      ),
                    ),
                    child:
                        authState.isLoading
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
                              AppStrings.createAccount,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.alreadyHaveAccount,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        onPressed:
                            authState.isLoading
                                ? null
                                : () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                        child: const Text(
                          AppStrings.login,
                          style: TextStyle(
                            color: AppColors.secondary,
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
