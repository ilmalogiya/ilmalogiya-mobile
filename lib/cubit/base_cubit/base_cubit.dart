import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../data/models/status/form_status.dart';
import '../../data/network/app_repository.dart';
import '../../data/network/custom_http_response.dart';
import '../../presentation/app_widgets/dialog/error_message_dialog.dart';

part 'base_state.dart';

class BaseCubit<TState extends BaseState> extends Cubit<TState> {
  BaseCubit({required TState state, required this.appRepository})
    : super(state);

  final AppRepository appRepository;

  Future<void> processApiRequest({
    BuildContext? context,
    required Future<CustomHttpResponse> request,
    required ValueChanged<dynamic> onSuccess,
    ValueChanged<String>? onFailure,
    bool showError = false,
    bool showLoader = true,
  }) async {
    emit(state.copyWith(status: FormStatus.submissionInProgress) as TState);

    if (context != null && context.mounted && showLoader) {
      context.loaderOverlay.show();
    }

    var result = await request;

    if (context != null && context.mounted && context.loaderOverlay.visible) {
      context.loaderOverlay.hide();
    }

    if (result.error.isNotEmpty) {
      _showErrorText(
        errorText: result.error,
        // ignore: use_build_context_synchronously
        context: context,
        onFailure: onFailure,
        showError: showError,
        progressLess: false,
      );
    } else {
      onSuccess.call(result.data ?? {});
      emit(state.copyWith(status: FormStatus.submissionSuccess) as TState);
      return;
    }
  }

  Future<void> processLessApiRequest({
    BuildContext? context, // if you want to show loader
    required Future<CustomHttpResponse> request,
    required ValueChanged<dynamic> onSuccess,
    ValueChanged<String>? onFailure,
    bool showError = false,
    bool showLoader = true,
  }) async {
    if (context != null && context.mounted && showLoader) {
      context.loaderOverlay.show();
    }

    var result = await request;

    if (context != null && context.mounted && context.loaderOverlay.visible) {
      context.loaderOverlay.hide();
    }

    if (result.error.isNotEmpty) {
      _showErrorText(
        errorText: result.error,
        // ignore: use_build_context_synchronously
        context: context,
        onFailure: onFailure,
        showError: showError,
        progressLess: true,
      );
    } else {
      onSuccess.call(result.data ?? {});
      return;
    }
  }

  Future<void> _showErrorText({
    required String errorText,
    BuildContext? context,
    ValueChanged<String>? onFailure,
    bool showError = false,
    required bool progressLess,
  }) async {
    if (!progressLess) {
      emit(
        state.copyWith(
              status: FormStatus.submissionFailure,
              errorMessage: context == null ? errorText : null,
            )
            as TState,
      );
    }
    if (onFailure != null) {
      onFailure.call(errorText);
    }
    if (!progressLess) {
      emit(
        state.copyWith(
              status: FormStatus.submissionFailure,
              errorMessage: context == null ? errorText : null,
            )
            as TState,
      );
    }
    if (showError && context != null && context.mounted) {
      await showErrorMessageDialog(message: errorText, context: context);
    }
  }
}
