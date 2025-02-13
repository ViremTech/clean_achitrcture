import 'package:clean_achitrcture/cores/error/failure.dart';
import 'package:clean_achitrcture/cores/util/input_converter.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/usecase/get_random_trivia_number.dart';
import 'package:clean_achitrcture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group(
    'GetTriviaForConcreteNumber',
    () {
      // The event takes in a String
      final tNumberString = '1';
      // This is the successful output of the InputConverter
      final tNumberParsed = int.parse(tNumberString);
      // NumberTrivia instance is needed too, of course
      final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

      test(
          'should call the InputConverter to validate and convert the string to an unsigned integer',
          () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        // when(mockGetConcreteNumberTrivia.call(any))
        //     .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      });

      test('should emit [Error] when the input is invalid', () {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // assert later
        final expected = [
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });

      test('should get data from the concrete use case', () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(tNumberParsed)));
      });

      test('should emit [Loading, Loaded] when data is gotten successfully',
          () {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });

      test('should emit [loading, error] when getting data fails', () {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });

      test(
          'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        final expected = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      });
    },
  );
  group(
    'GetTriviaForRandomNumber',
    () {
      // NumberTrivia instance is needed too, of course
      final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

      test('should get data from the random use case', () async {
        // arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      });

      test('should emit [Loading, Loaded] when data is gotten successfully',
          () {
        // arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // assert later
        final expected = [
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      });

      test('should emit [loading, error] when getting data fails', () {
        // arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(bloc.stream, emitsInOrder(expected));
        bloc.add(GetTriviaForRandomNumber());
      });

      test(
          'should emit [Loading, Error] with a proper message for the error when getting data fails',
          () {
        // arrange

        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        final expected = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForRandomNumber());
      });
    },
  );
}
