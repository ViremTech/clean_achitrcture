import 'dart:convert';

import 'package:clean_achitrcture/cores/error/excepton.dart';
import 'package:clean_achitrcture/features/number_trivia/data/data_source/number_trivia_local_data_source.dart';
import 'package:clean_achitrcture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';
  late NumberTriviaLocalDataSourceImpl localDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(
        fixture(
          'trivia_cached.json',
        ),
      ),
    );

    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(
        fixture(
          'trivia_cached.json',
        ),
      );
      final result = await localDataSource.getLastNumberTrivia();
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value',
        () async {
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      // Not calling the method here, just storing it inside a call variable
      final call = localDataSource.getLastNumberTrivia;
      // assert
      // Calling the method happens from a higher-order function passed.
      // This is needed to test if calling a method throws an exception.
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'test trivia');
    test('should call SharedPreferences to cache the data', () {
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());

      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);

      localDataSource.cacheNumberTrivia(tNumberTriviaModel);

      verify(
        mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, expectedJsonString),
      );
    });
  });
}
