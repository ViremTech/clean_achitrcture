import 'dart:convert';

import 'package:clean_achitrcture/cores/error/excepton.dart';
import 'package:clean_achitrcture/features/number_trivia/data/data_source/number_trivia_remote_data_source.dart';
import 'package:clean_achitrcture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late NumberTriviaRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockClient = MockClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(mockClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final uri = Uri.parse('http://numbersapi.com/$tNumber');
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should preform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      setUpMockHttpClientSuccess200();

      await remoteDataSource.getConcreteNumberTrivia(tNumber);

      verify(
        mockClient.get(
          uri,
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200();

      final result = await remoteDataSource.getConcreteNumberTrivia(tNumber);

      expect(result, tNumberTriviaModel);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () {
      setUpMockHttpClientFailure404();

      final call = remoteDataSource.getConcreteNumberTrivia;
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final uri = Uri.parse('http://numbersapi.com/random');
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
        'should preform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      setUpMockHttpClientSuccess200();

      await remoteDataSource.getRandomNumberTrivia();

      verify(
        mockClient.get(
          uri,
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200();

      final result = await remoteDataSource.getRandomNumberTrivia();

      expect(result, tNumberTriviaModel);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () {
      setUpMockHttpClientFailure404();

      final call = remoteDataSource.getRandomNumberTrivia;
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
