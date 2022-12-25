import 'package:flutter_clean_arc/core/platform/network_info.dart';
import 'package:flutter_clean_arc/core/util/input_converter.dart';
import 'package:flutter_clean_arc/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_arc/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_arc/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_clean_arc/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // featured - Number Trivia
  sl.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );

  // use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // core
  sl.registerLazySingleton(() => InputConverter());

  // repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // datasource
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTrivialLocalDataSourceImpl(sl()),
  );

  // core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(
    () => sharedPreferences,
  );

  sl.registerLazySingleton(
    () => http.Client(),
  );

  sl.registerLazySingleton(
    () => InternetConnectionChecker(),
  );
}
