import 'package:openid_client/openid_client_io.dart';
import 'package:url_launcher/url_launcher.dart';

Future<UserInfo> authenticate(
    String host, String realm, String clientId, List<String> scopes) async {
  Uri uri = Uri.parse('$host/auth/realms/$realm');
  var issuer = await Issuer.discover(uri);
  var client = Client(issuer, clientId);
  urlLauncher(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  Authenticator authenticator = Authenticator(client,
      scopes: scopes, port: 4000, urlLancher: urlLauncher);
  Credential c = await authenticator.authorize();
  closeWebView();
  return await c.getUserInfo();
}
