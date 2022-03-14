import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:udemy_cervantes/domain/helpers/helpers.dart';
import 'package:udemy_cervantes/data/usecases/remote_authentication.dart';
import 'package:udemy_cervantes/domain/usecases/authentication.dart';
import 'package:udemy_cervantes/data/http/http.dart';
import 'package:udemy_cervantes/data/usecases/usecases.dart';

void main() {
  HttpClientSpy httpClient;
  String url;
  RemoteAuthencation sut;
  AuthenticationParams params;

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthencation(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());
  });
  test('Should call HtppClient with correct Url', () async {
    final params = AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());
    await sut.auth(params);

    verify(httpClient.request(url: url, method: 'post', body: {'email': params.email, "password": params.password}));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    when(
      httpClient.request(
        url: anyNamed('url'),
        method: anyNamed('method'),
        body: anyNamed('body'),
      ),
    ).thenThrow(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}

class HttpClientSpy extends Mock implements HttpClient {}
