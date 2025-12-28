part of 'base_cubit.dart';

class BaseState extends Equatable {
  const BaseState({
    this.status = .pure,
    this.errorMessage = "",
    this.actionMessage = "",
  });

  final FormStatus status;
  final String errorMessage;
  final String actionMessage;

  BaseState copyWith({
    FormStatus? status,
    String? errorMessage,
    String? actionMessage,
  }) => BaseState(
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
    actionMessage: actionMessage ?? this.actionMessage,
  );

  @override
  List<Object?> get props => [errorMessage, actionMessage, status];
}
