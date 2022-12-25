import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arc/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';
import 'package:flutter_clean_arc/features/number_trivia/presentation/widgets/widgets.dart';
import 'package:flutter_clean_arc/injector_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }
}

BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
  return BlocProvider<NumberTriviaBloc>(
    create: (context) => sl<NumberTriviaBloc>(),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            // Top half
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return const MessageDisplay(
                    message: 'Start searching!',
                  );
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  return TriviaDisplay(numberTrivia: state.trivia);
                } else if (state is Error) {
                  return MessageDisplay(
                    message: state.error,
                  );
                }

                return const CircularProgressIndicator();
              },
            ),

            const SizedBox(height: 20),
            // Bottom half
            const TriviaControls(),
          ],
        ),
      ),
    ),
  );
}
