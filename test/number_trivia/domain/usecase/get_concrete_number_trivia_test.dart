import 'package:clean_achitrcture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetConcreteNumberTrivia usecase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });
  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');
  test('Should get NumberTrivia for number from the repository', () async {
    when(
      mockNumberTriviaRepository.getConcreteTriviaNumber(any),
    ).thenAnswer(
      (_) async => Right(tNumberTrivia),
    );

    final result = await usecase(Params(tNumber));
    expect(
      result,
      Right(tNumberTrivia),
    );

    verify(
      mockNumberTriviaRepository.getConcreteTriviaNumber(tNumber),
    );
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
