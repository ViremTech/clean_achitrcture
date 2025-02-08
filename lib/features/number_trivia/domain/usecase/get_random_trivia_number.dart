import 'package:clean_achitrcture/cores/error/failure.dart';
import 'package:clean_achitrcture/cores/usecase/usecase.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/repository/number_trivia_repository.dart';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetRandomNumberTrivia implements Usecase<NumberTrivia, NoParams> {
  NumberTriviaRepository numberTriviaRepository;
  GetRandomNumberTrivia(this.numberTriviaRepository);
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams param) {
    return numberTriviaRepository.getRandomTriviaNumber();
  }
}

class NoParams extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
