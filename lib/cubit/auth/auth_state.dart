part of "auth_cubit.dart";

class AuthState extends BaseState {
  const AuthState({
    super.status,
    super.actionMessage,
    super.errorMessage,
    required this.user,
    required this.isLoggedIn,
    required this.isGuest,
    this.isChecking = false,
  });

  final UserModel user;
  final bool isLoggedIn;
  final bool isGuest;
  final bool isChecking;

  factory AuthState.initial() => AuthState(
    user: UserModel.empty(),
    isLoggedIn: false,
    isGuest: false,
  );

  @override
  AuthState copyWith({
    FormStatus? status,
    String? actionMessage,
    String? errorMessage,
    UserModel? user,
    bool? isLoggedIn,
    bool? isGuest,
    bool? isChecking,
  }) {
    return AuthState(
      status: status ?? this.status,
      actionMessage: actionMessage ?? this.actionMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isGuest: isGuest ?? this.isGuest,
      isChecking: isChecking ?? this.isChecking,
    );
  }

  @override
  List<Object?> get props => [
    status,
    actionMessage,
    errorMessage,
    user,
    isLoggedIn,
    isGuest,
    isChecking,
  ];
}
