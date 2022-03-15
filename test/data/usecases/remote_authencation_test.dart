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

  Map mockValidData() => {'accessToken': faker.guid.guid(), 'name': faker.person.name()};

  PostExpectation mockRequest() => when(httpClient.request(url: anyNamed('url'), method: anyNamed('method'), body: anyNamed('body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAuthencation(httpClient: httpClient, url: url);
    params = AuthenticationParams(email: faker.internet.email(), password: faker.internet.password());
    mockHttpData(mockValidData());
  });

  test('Should call HtppClient with correct Url', () async {
    await sut.auth(params);

    verify(httpClient.request(url: url, method: 'post', body: {'email': params.email, "password": params.password}));
  });

  test('Should throw UnexpectedError if HttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvaliudCredentialsError if HttpClient returns 501', () async {
    mockHttpError(HttpError.unauthorized);

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);

    final account = await sut.auth(params);

    expect(account.token, validData['accessToken']);
  });

  test('Should return an Account if HttpClient returns 200 with invald data', () async {
    mockHttpData({'invalid_key': 'invalid_value'});

    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}

class HttpClientSpy extends Mock implements HttpClient {}
