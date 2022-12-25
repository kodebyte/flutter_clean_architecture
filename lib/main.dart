import 'package:flutter/material.dart';
import 'package:flutter_clean_arc/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injector_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const TriviaApp());
}

class TriviaApp extends StatelessWidget {
  const TriviaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primaryColor: Colors.green.shade800,
      ),
      home: const NumberTriviaPage(),
    );
  }
}
