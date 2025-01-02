import 'package:ditonton/common/init_io_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SSLCertifiedClient extends IOClient {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return await initializeIOClient().then((value) => value.get(url));
  }
}