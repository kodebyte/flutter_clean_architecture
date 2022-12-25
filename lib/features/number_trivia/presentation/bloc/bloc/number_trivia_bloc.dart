// ignore_for_file: constant_identifier_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_arc/core/error/failures.dart';
import 'package:flutter_clean_arc/core/usecases/usecase.dart';
import 'package:flutter_clean_arc/core/util/input_converter.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcretNumber>(
      (event, emit) async {
        final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);

        await inputEither.fold(
          (failure) {
            emit(
              const Error(error: INVALID_INPUT_FAILURE_MESSAGE),
            );
          },
          (integer) async {
            emit(Loading());

            final failureOrTrivia = await getConcreteNumberTrivia(
              Params(integer),
            );

            emit(
              failureOrTrivia.fold(
                (failure) {
                  return Error(
                    error: _mapFailureToMessage(failure),
                  );
                },
                (trivia) {
                  return Loaded(trivia: trivia);
                },
              ),
            );
          },
        );
      },
    );

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());

      final failureOrTrivia = await getRandomNumberTrivia(NoParams());

      emit(
        failureOrTrivia.fold(
          (failure) => Error(
            error: _mapFailureToMessage(failure),
          ),
          (trivia) => Loaded(trivia: trivia),
        ),
      );
    });
  }
}

String _mapFailureToMessage(Failure failure) {
  // Instead of a regular 'if (failure is ServerFailure)...'
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected Error';
  }
}
