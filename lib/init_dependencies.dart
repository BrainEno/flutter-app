import 'package:belog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:belog/core/network/connection_checker.dart';
import 'package:belog/core/secrets/app_secrets.dart';
import 'package:belog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:belog/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:belog/features/auth/domain/repository/auth_repository.dart';
import 'package:belog/features/auth/domain/usecases/current_user.dart';
import 'package:belog/features/auth/domain/usecases/user_login.dart';
import 'package:belog/features/auth/domain/usecases/user_sign_out.dart';
import 'package:belog/features/auth/domain/usecases/user_sign_up.dart';
import 'package:belog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:belog/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:belog/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:belog/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';
import 'package:belog/features/blog/domain/repositories/blog_repository.dart';
import 'package:belog/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:belog/features/blog/domain/usecase/upload_blog.dart';
import 'package:belog/features/blog/presentation/bloc/bloc/blog_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await dotenv.load(fileName: ".env");
  _initAuth();
  await _initBlog();

  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseKey ?? '');

  final directory = await getApplicationDocumentsDirectory();
  final isarInstance = await Isar.open(
    [BlogSchema], // Pass your Blog schema here
    directory: directory.path,
  );

  serviceLocator.registerLazySingleton(() => isarInstance);
  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerFactory(() => InternetConnection());
  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()));
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator<SupabaseClient>()))
    // Repository
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator(), serviceLocator()))
    // Usecases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => UserSignOut(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    // Bloc
    ..registerLazySingleton(() => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          userSignOut: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator(),
        ));
}

Future<void> _initBlog() async {
  // Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
        () => BlogRemoteDataSourceImpl(serviceLocator<SupabaseClient>()))
    ..registerFactory<BlogLocalDataSource>(
        () => BlogLocalDataSourceImpl(isar: serviceLocator<Isar>()))
    // Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        serviceLocator<BlogRemoteDataSource>(),
        serviceLocator<BlogLocalDataSource>(),
        serviceLocator<ConnectionChecker>(),
      ),
    )
    // Usecases
    ..registerFactory(() => UploadBlog(serviceLocator<BlogRepository>()))
    ..registerFactory(() => GetAllBlogs(serviceLocator<BlogRepository>()))
    // Bloc
    ..registerLazySingleton(() => BlogBloc(
          uploadBlog: serviceLocator<UploadBlog>(),
          getAllBlogs: serviceLocator<GetAllBlogs>(),
        ));
}
