import 'package:openid_client/openid_client_browser.dart';

Future<UserInfo?> authenticate(
    String host, String realm, String clientId, List<String> scopes) async {
  Uri uri = Uri.parse('$host/auth/realms/$realm');
  var issuer = await Issuer.discover(uri);
  var client = Client(issuer, clientId);

  var authenticator = Authenticator(
    client,
    scopes: scopes,
  );

  var c = await authenticator.credential;

  if (c == null) {
    authenticator.authorize();
    return null;
  } else {
    return await c.getUserInfo();
  }
}
