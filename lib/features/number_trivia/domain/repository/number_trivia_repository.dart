import 'package:clean_achitrcture/cores/error/failure.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getRandomTriviaNumber();
  Future<Either<Failure, NumberTrivia>> getConcreteTriviaNumber(int value);
}
