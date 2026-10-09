import "../../datasources/local/auth_local_data_source.dart";
import "../../models/user/auth_response_model.dart";
import "../../models/user/user_model.dart";
import "../../../utils/constants/endpoint_constants.dart";
import "../../../utils/app_logger.dart";
import "../custom_http_response.dart";
import "../http_requests_service.dart";
import "../services/google_sign_in_service.dart";

class AuthRepository {
  final AuthLocalDataSource _localDataSource = AuthLocalDataSource();
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  AuthLocalDataSource get localDataSource => _localDataSource;
  GoogleAuthService get googleAuthService => _googleAuthService;

  Future<CustomHttpResponse> loginWithGoogle(String idToken) async {
    final response = await HttpRequestsService.postRequest(
      endPoint: UrlConstants.authGoogle,
      body: {"id_token": idToken},
    );

    if (response.success && response.data != null) {
      try {
        final authResponse = AuthResponseModel.fromJson(
          response.data as Map<String, dynamic>,
        );
        await _localDataSource.saveTokens(
          access: authResponse.access,
          refresh: authResponse.refresh,
        );
        if (authResponse.user != null) {
          await _localDataSource.saveUser(authResponse.user!);
        }
      } catch (e) {
        AppLogger.e("Error parsing/saving auth data", e);
      }
    }
    return response;
  }

  Future<CustomHttpResponse> getMe() async {
    final token = await _localDataSource.getAccessToken();
    if (token == null) {
      return CustomHttpResponse(
        message: "No auth token",
        error: "No auth token",
        statusCode: 401,
      );
    }
    final response = await HttpRequestsService.getRequest(
      endPoint: UrlConstants.profileMe,
      token: token,
    );
    if (response.success && response.data != null) {
      try {
        final user = UserModel.fromJson(response.data as Map<String, dynamic>);
        await _localDataSource.saveUser(user);
      } catch (e) {
        AppLogger.e("Error parsing user profile", e);
      }
    }
    return response;
  }

  Future<void> logout() async {
    try {
      await _googleAuthService.signOut();
    } catch (e) {
      AppLogger.e("Google sign out error", e);
    }
    await _localDataSource.clearAuth();
  }

  Future<void> continueAsGuest() async {
    await _localDataSource.setGuestMode(true);
  }

  Future<bool> isLoggedIn() => _localDataSource.isLoggedIn();

  Future<bool> isGuest() => _localDataSource.isGuest();

  Future<UserModel?> getSavedUser() => _localDataSource.getUser();
}
