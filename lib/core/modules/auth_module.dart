import 'package:flutter_modular/flutter_modular.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/register/00_error_screen.dart';
import '../../features/auth/presentation/screens/register/01_phone_number_screen.dart';
import '../../features/auth/presentation/screens/register/02_verification_code_screen.dart';
import '../../features/auth/presentation/screens/register/03_name_screen.dart';
import '../../features/auth/presentation/screens/register/04_birth_date_screen.dart';
import '../../features/auth/presentation/screens/register/05_profile_confirmation_screen.dart';
import '../../features/auth/presentation/screens/register/06_follow_profiles_screen.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/services/phone_auth_service.dart';
import '../../features/auth/data/services/google_auth_service.dart';
import '../enums/user_type.dart';

/// Módulo de autenticación
class AuthModule extends Module {
  @override
  void binds(i) {
    // Servicios de autenticación
    i.addSingleton(PhoneAuthService.new);
    i.addSingleton(GoogleAuthService.new);
    i.addSingleton(AuthRepository.new);
    // Controllers ya están con Riverpod, no necesitan binding aquí
  }

  @override
  void routes(r) {
    // Pantalla de inicio de sesión
    r.child('/sign-in', child: (context) => const SignInScreen());

    // Pantalla de error (Ops!)
    r.child(
      '/error',
      child: (context) {
        final args = r.args.data ?? {};
        return ErrorScreen(
          phoneNumber: args['phoneNumber'],
          fromPhoneLogin: args['fromPhoneLogin'] ?? false,
          email: args['email'],
        );
      },
    );

    // Pantalla de ingreso de número telefónico
    r.child(
      '/phone',
      child: (context) {
        final args = r.args.data ?? {};
        final userTypeStr = args['userType'];
        final userType = userTypeStr == 'female'
            ? UserType.female
            : UserType.male;
        return PhoneNumberScreen(
          userType: userType,
          isLogin: args['isLogin'] ?? false,
          email: args['email'],
        );
      },
    );

    // Pantalla de verificación de código OTP
    r.child(
      '/verification',
      child: (context) {
        final args = r.args.data ?? {};
        final userTypeStr = args['userType'];
        final userType = userTypeStr == 'female'
            ? UserType.female
            : UserType.male;
        return VerificationCodeScreen(
          phoneNumber: args['phoneNumber'] ?? '',
          verificationId: args['verificationId'] ?? '',
          userType: userType,
          isLogin: args['isLogin'] ?? false,
          email: args['email'],
          isDevelopmentVerification: args['isDevelopmentVerification'] ?? false,
        );
      },
    );

    // Pantalla de registro de nombre
    r.child(
      '/name',
      child: (context) {
        final args = r.args.data ?? {};
        final userTypeStr = args['userType'];
        final userType = userTypeStr == 'female'
            ? UserType.female
            : UserType.male;
        return NameScreen(
          phoneNumber: args['phoneNumber'] ?? '',
          userType: userType,
          email: args['email'],
        );
      },
    );

    // Pantalla de fecha de nacimiento
    r.child(
      '/birthdate',
      child: (context) {
        final args = r.args.data ?? {};
        final userTypeStr = args['userType'];
        final userType = userTypeStr == 'female'
            ? UserType.female
            : UserType.male;
        return BirthDateScreen(
          phoneNumber: args['phoneNumber'] ?? '',
          name: args['name'] ?? '',
          userType: userType,
          email: args['email'],
        );
      },
    );

    // Pantalla de confirmación de perfil
    r.child(
      '/profile-confirmation',
      child: (context) {
        final args = r.args.data ?? {};
        final userTypeStr = args['userType'];
        final userType = userTypeStr == 'female'
            ? UserType.female
            : UserType.male;
        return ProfileConfirmationScreen(
          phoneNumber: args['phoneNumber'] ?? '',
          name: args['name'] ?? '',
          birthDate: args['birthDate'] ?? '',
          userType: userType,
          email: args['email'],
        );
      },
    );

    // Pantalla de seguir perfiles
    r.child(
      '/follow-profiles',
      child: (context) {
        final args = r.args.data ?? {};
        final userTypeStr = args['userType'];
        final userType = userTypeStr == 'female'
            ? UserType.female
            : UserType.male;
        return FollowProfilesScreen(
          phoneNumber: args['phoneNumber'] ?? '',
          name: args['name'] ?? '',
          username: args['username'] ?? '',
          birthDate: args['birthDate'] ?? '',
          email: args['email'],
          userType: userType,
        );
      },
    );
  }
}
