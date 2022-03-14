import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:udemy_cervantes/domain/usecases/authentication.dart';

void mani() {
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

class RemoteAuthencation {
  final HttpClient httpClient;
  final String url;

  RemoteAuthencation({@required this.httpClient, @required this.url});

  Future<void> auth(AuthenticationParams params) async {
    final body = {'email': params.email, 'password': params.password};

    await httpClient.request(
      url: url,
      method: 'post',
      body: body,
    );
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
    @required String method,
    Map body,
  });
}

class HttpClientSpy extends Mock implements HttpClient {}
