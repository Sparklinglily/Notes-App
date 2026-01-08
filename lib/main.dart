import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/core/constants/app_colors.dart';
import 'package:note_app/core/constants/app_strings.dart';
import 'package:note_app/firebase_options.dart';
import 'package:note_app/presentation/providers/auth_provider.dart';
import 'package:note_app/presentation/screens/auth/login_screen.dart';
import 'package:note_app/presentation/screens/auth/splash_screen.dart';
import 'package:note_app/presentation/screens/notes/notes_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          background: AppColors.background,
          surface: AppColors.surface,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// class AuthGate extends ConsumerWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authStateProvider);

//     return authState.when(
//       loading: () => const SplashScreen(),
//       error: (_, __) => const LoginScreen(),
//       data: (user) {
//         if (user == null) {
//           return const LoginScreen();
//         }
//         return const NotesListScreen();
//       },
//     );
//   }
// }
