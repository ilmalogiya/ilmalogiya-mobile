import "package:google_sign_in/google_sign_in.dart";
import "../../../utils/app_logger.dart";

class GoogleAuthService {
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await GoogleSignIn.instance.initialize();
      _initialized = true;
    }
  }

  Future<String?> getIdToken() async {
    try {
      await _ensureInitialized();
      final GoogleSignInAccount account =
          await GoogleSignIn.instance.authenticate();
      final String? idToken = account.authentication.idToken;
      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        AppLogger.w("Google sign in canceled by user");
        return null;
      }
      AppLogger.e("GoogleSignInException: ${e.code} - ${e.description}");
      rethrow;
    } catch (e, stack) {
      AppLogger.e("Google sign in error", e, stack);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _ensureInitialized();
      await GoogleSignIn.instance.signOut();
    } catch (e) {
      AppLogger.e("Google sign out error", e);
    }
  }
}
