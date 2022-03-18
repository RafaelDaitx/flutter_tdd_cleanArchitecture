import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final jsinBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(url, headers: headers, body: jsinBody);
    return _handleResponse(response);
  }

  Map _handleResponse(Response response) {
    if (response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    }
    throw HttpError.badRequest;
  }
}
