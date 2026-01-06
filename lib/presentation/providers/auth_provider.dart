import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_app/data/firebase_service/auth_service.dart';
import 'package:note_app/data/repository_impl/auth_repository_impl.dart';
import 'package:note_app/domain/entities/user.dart';
import 'package:note_app/domain/use_cases/auth_use_case/get_current_user.dart';
import 'package:note_app/domain/use_cases/auth_use_case/login_use_case.dart';
import 'package:note_app/domain/use_cases/auth_use_case/logout.dart';
import 'package:note_app/domain/use_cases/auth_use_case/sign_up.dart';
import 'package:riverpod/legacy.dart';

// Providers for dependencies
final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

final firebaseAuthDataSourceProvider = Provider<FirebaseAuthService>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthDataSourceImpl(firebaseAuth);
});

final authRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(firebaseAuthDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

// Use cases
final loginUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final signUpUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repository);
});

final logoutUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
});

final getCurrentUserUseCaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
});

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final useCase = ref.watch(getCurrentUserUseCaseProvider);
  return useCase.authStateChanges;
});

// Auth view model state
class AuthState {
  final bool isLoading;
  final String? error;
  final User? user;

  AuthState({this.isLoading = false, this.error, this.user});

  AuthState copyWith({bool? isLoading, String? error, User? user}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      user: user ?? this.user,
    );
  }
}

// Auth view model
class AuthViewModel extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthViewModel(this._loginUseCase, this._signUpUseCase, this._logoutUseCase)
    : super(AuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUseCase(email: email, password: password);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      },
    );
  }

  Future<bool> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _signUpUseCase(email: email, password: password);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    final result = await _logoutUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (_) {
        state = AuthState();
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  return AuthViewModel(
    ref.watch(loginUseCaseProvider),
    ref.watch(signUpUseCaseProvider),
    ref.watch(logoutUseCaseProvider),
  );
});
