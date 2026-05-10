part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const DUCKSCAN = _Paths.DUCKSCAN;
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const DUCK_MANAGEMENT = _Paths.DUCK_MANAGEMENT;
  static const NOTIFICATION = _Paths.NOTIFICATION;
  static const REPORT = _Paths.REPORT;
  static const PROFILE = _Paths.PROFILE;
}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const DUCKSCAN = '/duckscan';
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const DUCK_MANAGEMENT = '/duck-management';
  static const NOTIFICATION = '/notification';
  static const REPORT = '/report';
  static const PROFILE = '/profile';
}
