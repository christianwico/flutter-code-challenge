import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_code_challenge/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Auth extends ChangeNotifier {
  String? name;
  String? githubPageUrl;
  String? errorMessage;
  bool isBusy = false;
  bool isLoggedIn = false;

  Map<String, dynamic> _parseIdToken(String idToken) {
    final List<String> parts = idToken.split(r'.');

    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<void> _updateProfile(TokenResponse result) async {
    final Map<String, dynamic> idToken = _parseIdToken(result.idToken!);
    final Map<String, dynamic> profile =
        await _getUserDetails(result.accessToken!);

    await FlutterSecureStorage().write(
      key: Constants.SECURE_REFRESH_TOKEN,
      value: result.refreshToken!,
    );

    isBusy = true;
    isLoggedIn = true;
    name = idToken['name'];
    githubPageUrl = 'https://github.com/${profile['nickname']}';

    notifyListeners();
  }

  Future<Map<String, dynamic>> _getUserDetails(String accessToken) async {
    final Uri uri = Uri.parse('https://${Constants.AUTH0_DOMAIN}/userinfo');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  void init() async {
    final String? refreshToken =
        await FlutterSecureStorage().read(key: Constants.SECURE_REFRESH_TOKEN);

    if (refreshToken == null) {
      return;
    }

    // TODO: Do not refresh if not needed.

    isBusy = true;

    notifyListeners();

    try {
      final FlutterAppAuth appAuth = FlutterAppAuth();
      final TokenResponse? result = await appAuth.token(TokenRequest(
        Constants.AUTH0_CLIENT_ID,
        Constants.AUTH0_REDIRECT_URI,
        issuer: Constants.AUTH0_ISSUER,
        refreshToken: refreshToken,
      ));

      await _updateProfile(result!);
    } catch (e, s) {
      print('[LOGIN ERROR]: $e - $s');
      logoutAction();
    }
  }

  Future<void> loginAction() async {
    isBusy = true;
    errorMessage = null;

    try {
      final FlutterAppAuth appAuth = FlutterAppAuth();
      final AuthorizationTokenResponse? result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Constants.AUTH0_CLIENT_ID,
          Constants.AUTH0_REDIRECT_URI,
          issuer: Constants.AUTH0_ISSUER,
          scopes: ['openid', 'profile', 'offline_access'],
          promptValues: ['login'],
        ),
      );

      await _updateProfile(result!);
    } catch (e, s) {
      print('[LOGIN ERROR]: $e - $s');

      isBusy = false;
      isLoggedIn = false;
      errorMessage = e.toString();

      notifyListeners();
    }
  }

  void logoutAction() async {
    await FlutterSecureStorage().delete(key: Constants.SECURE_REFRESH_TOKEN);

    isLoggedIn = false;
    isBusy = false;

    notifyListeners();
  }
}

enum AuthState { LOGGED_IN, NOT_LOGGED_IN }
