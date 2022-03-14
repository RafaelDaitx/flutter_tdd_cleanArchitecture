import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:udemy_cervantes/data/usecases/remote_authentication.dart';
import 'package:udemy_cervantes/domain/usecases/authentication.dart';
import 'package:udemy_cervantes/data/http/http.dart';
import 'package:udemy_cervantes/data/usecases/usecases.dart';

void main() {
  HttpClientSpy httpClient;
  String url;
  RemoteAuthencation sut;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthencation(httpClient: httpClient, url: url);
  });
  test('Should call HtppClient with correct Url', () async {
    final params = AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());
    await sut.auth(params);

    verify(httpClient.request(url: url, method: 'post', body: {'email': params.email, "password": params.password}));
  });
}

class HttpClientSpy extends Mock implements HttpClient {}
