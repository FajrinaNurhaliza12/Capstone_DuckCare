part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME             = _Paths.HOME;
  static const DUCKSCAN         = _Paths.DUCKSCAN;
  static const SPLASH           = _Paths.SPLASH;
  static const LOGIN            = _Paths.LOGIN;
  static const REGISTER         = _Paths.REGISTER;
  static const DUCK_MANAGEMENT  = _Paths.DUCK_MANAGEMENT;
  static const PROFILE          = _Paths.PROFILE;
  static const NOTIFICATION     = _Paths.NOTIFICATION;
  static const REPORT           = _Paths.REPORT;
  static const OTP              = _Paths.OTP;
  static const FORGOT_PASSWORD  = _Paths.FORGOT_PASSWORD;
  static const RESET_PASSWORD   = _Paths.RESET_PASSWORD;
}

abstract class _Paths {
  _Paths._();

  static const HOME             = '/home';
  static const DUCKSCAN         = '/duckscan';
  static const SPLASH           = '/splash';
  static const LOGIN            = '/login';
  static const REGISTER         = '/register';
  static const DUCK_MANAGEMENT  = '/duck-management';
  static const PROFILE          = '/profile';
  static const NOTIFICATION     = '/notification';
  static const REPORT           = '/report';
  static const OTP              = '/otp';
  static const FORGOT_PASSWORD  = '/forgot-password';
  static const RESET_PASSWORD   = '/reset-password';
}