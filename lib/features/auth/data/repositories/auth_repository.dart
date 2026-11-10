import 'package:firebase_auth/firebase_auth.dart';
import '../services/phone_auth_service.dart';
import '../services/google_auth_service.dart';

class AuthRepository {
  final PhoneAuthService _phoneAuthService;
  final GoogleAuthService _googleAuthService;

  AuthRepository(this._phoneAuthService, this._googleAuthService);

  Future<String> sendPhoneOTP(String phoneNumber) async {
    return await _phoneAuthService.sendOTP(phoneNumber);
  }

  Future<User?> verifyPhoneOTP({
    required String verificationId,
    required String otp,
    required String phoneNumber,
  }) async {
    return await _phoneAuthService.verifyOTP(
      verificationId: verificationId,
      otp: otp,
      phoneNumber: phoneNumber,
    );
  }

  Future<User> signInAnonymously() {
    return _phoneAuthService.signInAnonymously();
  }

  User? getCurrentUser() {
    return _phoneAuthService.getCurrentUser();
  }

  Future<bool> checkUserExists(String uid) async {
    return await _phoneAuthService.checkUserExists(uid);
  }

  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String username,
    required DateTime birthDate,
    String? email,
    String? photoUrl,
  }) async {
    await _phoneAuthService.updateUserProfile(
      userId: userId,
      name: name,
      username: username,
      birthDate: birthDate,
      email: email,
      photoUrl: photoUrl,
    );
  }

  Future<void> signOut() async {
    await _phoneAuthService.signOut();
    await _googleAuthService.signOut();
  }

  Future<void> saveUserType({
    required String userId,
    required String userType,
  }) async {
    await _phoneAuthService.saveUserType(userId: userId, userType: userType);
  }

  // Google Sign In methods
  Future<User?> signInWithGoogle() async {
    return await _googleAuthService.signInWithGoogle();
  }

  /// Crea el documento del usuario en Firestore (para usuarios de Google)
  Future<void> createGoogleUserDocument({
    required String uid,
    required String name,
    required String username,
    required String phone,
    required DateTime birthDate,
    required String userType,
    String? photoUrl,
  }) async {
    await _googleAuthService.createUserDocument(
      uid: uid,
      name: name,
      username: username,
      phone: phone,
      birthDate: birthDate,
      userType: userType,
      photoUrl: photoUrl,
    );
  }
}
