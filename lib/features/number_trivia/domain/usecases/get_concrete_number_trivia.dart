import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_arc/core/error/failures.dart';
import 'package:flutter_clean_arc/core/usecases/usecase.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/entities/number_trivia.dart';

class GetConcreteNumberTrivia extends Usercase<Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params(
    this.number,
  );

  @override
  List<Object?> get props => [number];
}
