import 'package:clean_achitrcture/cores/networks/network_info.dart';
import 'package:clean_achitrcture/cores/util/input_converter.dart';
import 'package:http/http.dart' as http;
import 'package:clean_achitrcture/features/number_trivia/data/data_source/number_trivia_local_data_source.dart';
import 'package:clean_achitrcture/features/number_trivia/data/data_source/number_trivia_remote_data_source.dart';
import 'package:clean_achitrcture/features/number_trivia/data/respository/number_trivia_repository_impl.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/repository/number_trivia_repository.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/usecase/get_concrete_number_trivia.dart';
import 'package:clean_achitrcture/features/number_trivia/domain/usecase/get_random_trivia_number.dart';
import 'package:clean_achitrcture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Service locator instance
final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        concrete: sl(),
        random: sl(),
        inputConverter: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Core
  sl.registerLazySingleton(() => InputConverter());

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(
            remoteDataSource: sl(),
            localDataSource: sl(),
            networkInfo: sl(),
          ));

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()));

  // Network info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
}
