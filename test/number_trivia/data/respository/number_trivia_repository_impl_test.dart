import 'package:clean_achitrcture/cores/error/excepton.dart';
import 'package:clean_achitrcture/cores/error/failure.dart';
import 'package:clean_achitrcture/cores/platform/network_info.dart';
import 'package:clean_achitrcture/features/number_trivia/data/data_source/number_trivia_local_data_source.dart';
import 'package:clean_achitrcture/features/number_trivia/data/data_source/number_trivia_remote_data_source.dart';
import 'package:clean_achitrcture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_achitrcture/features/number_trivia/data/respository/number_trivia_repository_impl.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
// import 'package:clean_achitrcture/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaRemoteDataSource])
@GenerateMocks([NumberTriviaLocalDataSource])
@GenerateMocks([NetworkInfo])
void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group(
    'getConcreteNumberTrivia',
    () {
      // DATA FOR THE MOCKS AND ASSERTIONS
      // We'll use these three variables throughout all the tests
      final tNumber = 1;
      final tNumberTriviaModel =
          NumberTriviaModel(number: tNumber, text: 'test trivia');
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test('should check if the device is online', () async {
        when(mockNetworkInfo.isConnected).thenAnswer(
          (_) async => true,
        );
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        await repositoryImpl.getConcreteTriviaNumber(
          tNumber,
        );
        verify(
          mockNetworkInfo.isConnected,
        );
      });

      group(
        'test online',
        () {
          setUp(
            () {
              when(mockNetworkInfo.isConnected).thenAnswer(
                (_) async => true,
              );
            },
          );

          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                  .thenAnswer((_) async => tNumberTriviaModel);
              final result =
                  await repositoryImpl.getConcreteTriviaNumber(tNumber);
              verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              expect(
                result,
                equals(
                  Right(
                    tNumberTriviaModel,
                  ),
                ),
              );
            },
          );
          test(
              'should cache the data locally when the call to remote data source is successful',
              () async {
            when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                .thenAnswer((_) async => tNumberTriviaModel);

            await repositoryImpl.getConcreteTriviaNumber(tNumber);
            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verify(mockLocalDataSource
                .cacheNumberTrivia(tNumberTrivia as NumberTriviaModel?));
          });
          test(
              'should return server failure when the call to remote data source is unsuccessful',
              () async {
            when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
                .thenThrow(
              ServerException(),
            );

            final result =
                await repositoryImpl.getConcreteTriviaNumber(tNumber);
            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          });
        },
      );
      group('Offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer(
            (_) async => false,
          );
        });
        test(
            'should return last locally cached data when the cached data is present',
            () async {
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          final result = await repositoryImpl.getConcreteTriviaNumber(tNumber);

          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        });

        test('should return CacheFailure when there is no cached data present',
            () async {
          when(mockLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          final result = await repositoryImpl.getConcreteTriviaNumber(tNumber);

          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, equals(left(CacheFailure())));
        });
      });
    },
  );

  group(
    'getRandomTriviaNumber',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel(number: 123, text: 'test trivia');
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;

      test('should check if the device is online', () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        await repositoryImpl.getRandomTriviaNumber();
        verify(mockNetworkInfo.isConnected);
        verify(mockRemoteDataSource.getRandomNumberTrivia());
      });
      group('test online', () {
        setUp(
          () {
            when(mockNetworkInfo.isConnected).thenAnswer(
              (_) async => true,
            );
          },
        );
        test(
            'should return remote data when the call to remote data source is successful',
            () async {
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          final result = await repositoryImpl.getRandomTriviaNumber();

          expect(result, Right(tNumberTrivia));
        });

        test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          await repositoryImpl.getRandomTriviaNumber();
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource
              .cacheNumberTrivia(tNumberTrivia as NumberTriviaModel?));
        });
        test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
          when(mockRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());

          final result = await repositoryImpl.getRandomTriviaNumber();
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, Left(ServerFailure()));
        });
        group('Offline', () {
          setUp(() {
            when(mockNetworkInfo.isConnected).thenAnswer(
              (_) async => false,
            );
          });
          test(
              'should return last locally cached data when the cached data is present',
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            final result = await repositoryImpl.getRandomTriviaNumber();
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, Right(tNumberTrivia));
          });
          test(
              'should return CacheFailure when there is no cached data present',
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());

            final result = await repositoryImpl.getRandomTriviaNumber();
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          });
        });
      });
    },
  );
}
