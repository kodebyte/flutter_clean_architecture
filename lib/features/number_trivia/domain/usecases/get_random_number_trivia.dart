import 'package:flutter_clean_arc/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arc/core/usecases/usecase.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/entities/number_trivia.dart';

class GetRandomNumberTrivia extends Usercase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
