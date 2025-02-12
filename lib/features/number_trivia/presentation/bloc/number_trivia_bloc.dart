import 'package:bloc/bloc.dart';
import 'package:clean_achitrcture/cores/util/input_converter.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/usecase/get_random_trivia_number.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;
  NumberTriviaBloc(
      {required this.concrete,
      required this.random,
      required this.inputConverter})
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        emit(inputEither.fold(
            (failure) => Error(message: INVALID_INPUT_FAILURE_MESSAGE),
            (integer) => throw UnimplementedError()));
      }
    });
  }
}
