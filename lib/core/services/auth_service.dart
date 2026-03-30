import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // In version 7.x, GoogleSignIn uses a singleton instance
  GoogleSignIn get _googleSignIn => GoogleSignIn.instance;

  // ⚠️ Replace this placeholder with your actual Web Client ID from Google Cloud Console
  // This is required for retrieving the idToken on Android.
  static const String _serverClientId =
      "1090873536352-2875990649585.apps.googleusercontent.com";

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize(serverClientId: _serverClientId);

      final GoogleSignInAccount? googleUser = await _googleSignIn
          .authenticate();
      return googleUser;
    } catch (error) {
      log("Google SignIn Error: $error");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      log("SignOut Error: $error");
    }
  }
}
