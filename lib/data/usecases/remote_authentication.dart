import 'package:meta/meta.dart';

import '../../domain/helpers/helpers.dart';
import 'package:udemy_cervantes/domain/helpers/domain_error.dart';
import '../../domain/usecases/authentication.dart';

import '../http/http.dart';

class RemoteAuthencation {
  final HttpClient httpClient;
  final String url;

  RemoteAuthencation({@required this.httpClient, @required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      await httpClient.request(
        url: url,
        method: 'post',
        body: body,
      );
    } on HttpError catch (error) {
      throw error == HttpError.unauthorized ? DomainError.invalidCredentials : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    @required this.email,
    @required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) => RemoteAuthenticationParams(email: params.email, password: params.password);

  Map toJson() => {'email': email, 'password': password};
}
