import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:openid_client/openid_client.dart';
import 'stub.dart'
    if (dart.library.io) 'mobile.dart'
    if (dart.library.html) 'web.dart';

class LoginResult {
  UserInfo? userInfo;
  String? logoutUrl;
  LoginResult({this.userInfo, this.logoutUrl});
}

class KeycloakLogin {
  String host;
  String realm;
  String clientId;
  List<String> scopes;
  Widget Function(VoidCallback)? onBeforeLogin;
  Widget Function(LoginResult?) onSuccess;
  LoginResult? loginResult;
  KeycloakLogin({
    required this.host,
    required this.realm,
    required this.clientId,
    required this.scopes,
    this.onBeforeLogin,
    required this.onSuccess,
  });
  void run() async {
    if (kIsWeb) {
      String? uri = Uri.base.toString().replaceAll('#', '?');
      String? token = Uri.parse(uri).queryParameters['access_token'];
      if (token == null) {
        if (onBeforeLogin != null) {
          runApp(onBeforeLogin!(_gotoLogin));
        } else {
          _gotoLogin();
        }
      } else {
        runApp(onSuccess(loginResult));
      }
    } else {
      WidgetsFlutterBinding.ensureInitialized();
      if (onBeforeLogin != null) {
        runApp(onBeforeLogin!(_gotoLogin));
      } else {
        _gotoLogin();
        runApp(onSuccess(loginResult));
      }
    }
  }

  void _gotoLogin() async {
    loginResult = await authenticate(host, realm, clientId, scopes);
  }

  void urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _logout() async {
    urlLauncher(loginResult!.logoutUrl!);
  }
}
