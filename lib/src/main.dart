import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'stub.dart'
    if (dart.library.io) 'mobile.dart'
    if (dart.library.html) 'web.dart';

class KeycloakLogin {
  String host;
  String realm;
  String clientId;
  List<String> scopes;
  ValueSetter<String> onSuccess;
  //Widget? beforeLoginPage;
  KeycloakLogin({
    required this.host,
    required this.realm,
    required this.clientId,
    required this.scopes,
    required this.onSuccess,
  });
  void run() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) {
      String? uri = Uri.base.toString().replaceAll('#', '?');
      String? token = Uri.parse(uri).queryParameters['access_token'];
      if (token == null) {
        await authenticate(host, realm, clientId, scopes);
      } else {
        onSuccess(token);
      }
    } else {
      await authenticate(host, realm, clientId, scopes);
      onSuccess('ok');
    }
  }
}
