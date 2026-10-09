import "package:flutter/material.dart";

import "../../data/models/status/form_status.dart";
import "../../data/models/user/auth_response_model.dart";
import "../../data/models/user/user_model.dart";
import "../../utils/app_logger.dart";
import "../base_cubit/base_cubit.dart";

part "auth_state.dart";

class AuthCubit extends BaseCubit<AuthState> {
  AuthCubit({required super.appRepository}) : super(state: AuthState.initial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(isChecking: true));
    final bool loggedIn = await appRepository.authRepository.isLoggedIn();
    final bool guest = await appRepository.authRepository.isGuest();
    final UserModel? savedUser =
        await appRepository.authRepository.getSavedUser();

    emit(
      state.copyWith(
        isChecking: false,
        isLoggedIn: loggedIn,
        isGuest: guest,
        user: savedUser ?? UserModel.empty(),
      ),
    );

    if (loggedIn) {
      // Refresh profile in background
      appRepository.authRepository.getMe().then((response) {
        if (response.success && response.data != null) {
          final updated =
              UserModel.fromJson(response.data as Map<String, dynamic>);
          emit(state.copyWith(user: updated));
        }
      });
    }
  }

  Future<void> signInWithGoogle({
    required BuildContext context,
    VoidCallback? onSuccess,
  }) async {
    try {
      emit(state.copyWith(status: FormStatus.submissionInProgress));
      final String? idToken =
          await appRepository.authRepository.googleAuthService.getIdToken();

      if (idToken == null) {
        // User cancelled
        emit(state.copyWith(status: FormStatus.pure));
        return;
      }

      if (!context.mounted) return;

      await processApiRequest(
        context: context,
        showError: true,
        request: appRepository.authRepository.loginWithGoogle(idToken),
        onSuccess: (result) {
          final authResponse =
              AuthResponseModel.fromJson(result as Map<String, dynamic>);
          emit(
            state.copyWith(
              status: FormStatus.submissionSuccess,
              isLoggedIn: true,
              isGuest: false,
              user: authResponse.user ?? state.user,
            ),
          );
          onSuccess?.call();
        },
        onFailure: (error) {
          emit(
            state.copyWith(
              status: FormStatus.submissionFailure,
              errorMessage: error,
            ),
          );
        },
      );
    } catch (e, stack) {
      AppLogger.e("Google login cubit error", e, stack);
      emit(
        state.copyWith(
          status: FormStatus.submissionFailure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> continueAsGuest({VoidCallback? onDone}) async {
    await appRepository.authRepository.continueAsGuest();
    emit(state.copyWith(isGuest: true));
    onDone?.call();
  }

  Future<void> logout() async {
    await appRepository.authRepository.logout();
    emit(AuthState.initial());
  }
}
