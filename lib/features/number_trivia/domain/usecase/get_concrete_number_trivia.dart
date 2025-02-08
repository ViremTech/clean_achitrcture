import 'package:clean_achitrcture/cores/error/failure.dart';
import 'package:clean_achitrcture/cores/usecase/usecase.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/entities/number_trivia.dart';
// import 'package:clean_achitrcture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTrivia, Params> {
  NumberTriviaRepository numberTriviaRepository;
  GetConcreteNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params param) async {
    return await numberTriviaRepository.getConcreteTriviaNumber(param.param);
  }
}

class Params extends Equatable {
  final int param;
  const Params(this.param);

  @override
  // TODO: implement props
  List<Object?> get props => [param];
}
