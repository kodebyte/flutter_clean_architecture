import 'package:flutter_clean_arc/core/error/exception.dart';
import 'package:flutter_clean_arc/core/platform/network_info.dart';
import 'package:flutter_clean_arc/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_arc/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_arc/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arc/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    if (await networkInfo.isConnected) {
      return getConcreteNumberTriviaFromRemoteDataSource(number);
    } else {
      return getConcreteNumberTriviaFromLocalDataSource();
    }
  }

  Future<Either<Failure, NumberTrivia>> getConcreteNumberTriviaFromRemoteDataSource(int number) async {
    try {
      final remoteTrivia = await remoteDataSource.getConcreteNumberTrivia(number);
      localDataSource.cacheNumberTrivia(remoteTrivia);

      return Right(remoteTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, NumberTrivia>> getConcreteNumberTriviaFromLocalDataSource() async {
    try {
      final localTrivia = await localDataSource.getLastNumberTrivia();
      return Right(localTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    if (await networkInfo.isConnected) {
      return getRandomNumberTriviaFromRemoteDataSource();
    } else {
      return getRandomNumberTriviaFromLocalDataSource();
    }
  }

  Future<Either<Failure, NumberTrivia>> getRandomNumberTriviaFromRemoteDataSource() async {
    try {
      final remoteTrivia = await remoteDataSource.getRandomNumberTrivia();
      localDataSource.cacheNumberTrivia(remoteTrivia);

      return Right(remoteTrivia);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, NumberTrivia>> getRandomNumberTriviaFromLocalDataSource() async {
    try {
      final localTrivia = await localDataSource.getLastNumberTrivia();
      return Right(localTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
