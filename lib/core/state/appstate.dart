// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qent_app/core/configurations/app_configurations.dart';
import 'package:qent_app/core/utils/constants/app_constant.dart';
import 'package:qent_app/features/auth/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateModel with ChangeNotifier, WidgetsBindingObserver {
  bool _authenticated = false;
  bool _rememberMe = false;
  String? _userToken;
  String? _firebaseToken;
  String? _idToken;
  String? _refreshToken;
  double? _longitude;
  double? _latitude;
  UserModel? _userCurrent;
  String? _email;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  double? get longitude => _longitude;
  double? get latitude => _latitude;

  setLocation(double latitudeValue, double longitudeValue) {
    _longitude = longitudeValue;
    _latitude = latitudeValue;
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    prefs.setString(
      AppConstant.THEME_MODE,
      _themeMode == ThemeMode.dark
          ? 'dark'
          : _themeMode == ThemeMode.light
              ? 'light'
              : 'system',
    );
    notifyListeners();
  }

  void loadThemeMode() {
    final themeStr = prefs.getString(AppConstant.THEME_MODE);
    if (themeStr == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (themeStr == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  DateTime? _expiresAt;
  bool get isTokenExpired {
    if (_userToken == null) {
      return true;
    }
    if (_expiresAt == null && _userToken != null) return true;
    final remaining = _expiresAt!.difference(DateTime.now().toUtc());
    if (remaining.inSeconds < 700) {
      return true;
    }
    return false;
  }

  bool get authenticated => _authenticated;
  bool get hasActiveSession =>
      _authenticated &&
      _userToken != null &&
      _userToken!.isNotEmpty &&
      !isTokenExpired;

  String? get userToken => _userToken;

  String? get firebaseToken => _firebaseToken;

  String? get idToken => _idToken;

  String? get refreshToken => _refreshToken;

  String? get email => _email;

  DateTime? get expiresAt => _expiresAt;
  UserModel? get userCurrent => _userCurrent;

  static bool isRestartingApp = false;

  bool get stayLoggedIn => _rememberMe;

  set stayLoggedIn(bool value) {
    _rememberMe = value;
    prefs.setBool(AppConstant.IS_STAY_LOGGED, value);
  }

  Future<void> refresh(
    String token,
    String? refreshToken,
    String? expire,
  ) async {
    _userToken = token;
    _refreshToken = refreshToken;
    _authenticated = token.isNotEmpty;
    final normalizedExpire = (expire == null || expire.isEmpty)
        ? null
        : expire.replaceFirstMapped(
            RegExp(r'\.(\d{6})\d*Z$'),
            (m) => ".${m[1]}Z",
          );
    _expiresAt = normalizedExpire == null
        ? DateTime.now().toUtc().add(const Duration(days: 30))
        : DateTime.tryParse(normalizedExpire)?.toUtc();
    await prefs.remove(AppConstant.TOKEN);
    await prefs.remove(AppConstant.RefreshTOKEN);
    await prefs.remove(AppConstant.ExpireAt);
    await prefs.setString(AppConstant.TOKEN, token);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await prefs.setString(AppConstant.RefreshTOKEN, refreshToken);
    }
    if (_expiresAt != null) {
      await prefs.setString(
        AppConstant.ExpireAt,
        _expiresAt!.toIso8601String(),
      );
    }
    await prefs.setBool(AppConstant.IS_LOGGED_IN, _authenticated);

    notifyListeners();
  }

  Future<void> logOut() async {
    _authenticated = false;
    _userToken = null;
    _idToken = null;
    _refreshToken = null;
    _userCurrent = null;
    _email = null;
    // _themeMode = ThemeMode.light;
    // _expires = null;
    _expiresAt = null;

    await prefs.remove(AppConstant.TOKEN);
    await prefs.remove(AppConstant.FB_TOKEN);
    await prefs.remove(AppConstant.RefreshTOKEN);
    await prefs.remove(AppConstant.ExpireAt);

    await prefs.remove(AppConstant.IS_LOGGED_IN);
    await prefs.remove(AppConstant.IS_STAY_LOGGED);
    await prefs.remove(AppConstant.User_Id);

    notifyListeners();
  }

  //
  final SharedPreferences prefs;
  AppStateModel(this.prefs);
  saveUser(UserModel? user) {
    _userCurrent = user;
    _email = user?.email;
    //
    notifyListeners();
    //   if (_accountCreationTime == null && user?.createdAt != null) {
    //   _accountCreationTime = DateTime.parse(user!.createdAt!);
    // }
  }

  Future init() async {
    loadThemeMode();

    // ---------------------------
    // Load filters (safe parsing)
    // ---------------------------

    // ---------------------------
    // Load tokens
    // ---------------------------
    _userToken = prefs.getString(AppConstant.TOKEN);
    _refreshToken = prefs.getString(AppConstant.RefreshTOKEN);

    // Expiration as ISO string
    final expiresStr = prefs.getString(AppConstant.ExpireAt) ?? '';

    _expiresAt =
        expiresStr.isEmpty ? null : DateTime.tryParse(expiresStr)?.toUtc();

    // Remember Me
    _rememberMe = prefs.getBool(AppConstant.IS_STAY_LOGGED) ?? false;

    // Set authenticated flag from token existence
    _authenticated = _userToken != null && _userToken!.isNotEmpty;
    if (_authenticated && isTokenExpired) {
      await logOut();
    }

    // Load saved user profile

    // ---------------------------
    // Refresh token if expired
    // ---------------------------

    // ---------------------------
    // Determine user mode
    // ---------------------------

    // Device info
    await AppConfigurations.initDeviceInfo();

    // Add lifecycle observer (only once)
  }
}
