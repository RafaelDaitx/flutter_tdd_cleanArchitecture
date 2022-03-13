import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void mani() {
  test('Should call HtppClient with correct Url', () async {
    final httpClient = HttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthencation(httpClient: httpClient, url: url);
    await sut.auth();

    verify(httpClient.request(url: url));
  });
}

class RemoteAuthencation {
  final HttpClient httpClient;
  final String url;

  RemoteAuthencation({@required this.httpClient, @required this.url});

  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class HttpClient {
  Future<void> request({
    @required String url,
  });
}

class HttpClientSpy extends Mock implements HttpClient {}
