import 'package:flutter/foundation.dart';

@immutable
class AuthState {
  final bool isLoading;
  final bool isLoggedIn;
  final String? userType; // "mr" or "doctor"
  final Map<String, dynamic>? userData;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.isLoggedIn = false,
    this.userType,
    this.userData,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isLoggedIn,
    String? userType,
    Map<String, dynamic>? userData,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      userType: userType ?? this.userType,
      userData: userData ?? this.userData,
      errorMessage: errorMessage,
    );
  }
}
