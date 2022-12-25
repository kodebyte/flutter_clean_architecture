import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_arc/core/error/failures.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/entities/number_trivia.dart';

abstract class Usercase<Type, Params> {
  Future<Either<Failure, NumberTrivia>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
