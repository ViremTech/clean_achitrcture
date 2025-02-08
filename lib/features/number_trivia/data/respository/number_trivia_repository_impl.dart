import 'package:clean_achitrcture/cores/error/failure.dart';
import 'package:clean_achitrcture/cores/platform/network_info.dart';
import 'package:clean_achitrcture/features/number_trivia/data/data_source/number_trivia_local_data_source.dart';
import 'package:clean_achitrcture/features/number_trivia/data/data_source/number_trivia_remote_data_source.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  NumberTriviaRemoteDataSource remoteDataSource;
  NumberTriviaLocalDataSource localDataSource;
  NetworkInfo networkInfo;
  NumberTriviaRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteTriviaNumber(int value) {
    // TODO: implement getConcreteTriviaNumber
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomTriviaNumber() {
    // TODO: implement getRandomTriviaNumber
    throw UnimplementedError();
  }
}
