part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  const Loaded({
    required this.trivia,
  });

  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaState {
  final String error;

  const Error({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}
