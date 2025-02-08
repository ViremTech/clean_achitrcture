import 'package:clean_achitrcture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/repository/number_trivia_repository.dart';

import 'package:clean_achitrcture/features/number_trivia/domain/usecase/get_random_trivia_number.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetRandomNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');
  test('Should get NumberTrivia for random number from the repository',
      () async {
    when(
      mockNumberTriviaRepository.getRandomTriviaNumber(),
    ).thenAnswer(
      (_) async => Right(tNumberTrivia),
    );

    final result = await usecase(NoParams());
    expect(
      result,
      Right(tNumberTrivia),
    );

    verify(
      mockNumberTriviaRepository.getRandomTriviaNumber(),
    );
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
