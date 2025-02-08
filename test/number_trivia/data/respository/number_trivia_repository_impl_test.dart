import 'package:clean_achitrcture/cores/platform/network_info.dart';
import 'package:clean_achitrcture/features/number_trivia/data/data_source/number_trivia_local_data_source.dart';
import 'package:clean_achitrcture/features/number_trivia/data/data_source/number_trivia_remote_data_source.dart';
import 'package:clean_achitrcture/features/number_trivia/data/respository/number_trivia_repository_impl.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/repository/number_trivia_repository.dart';
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
    repositoryImpl = NumberTriviaRepositoryImpl(
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
      remoteDataSource: mockRemoteDataSource,
    );
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
  });
}
