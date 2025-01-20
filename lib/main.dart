import 'package:belog/core/secrets/app_secrets.dart';
import 'package:belog/core/theme/theme.dart';
import 'package:belog/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:belog/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:belog/features/auth/domain/usecases/user_sign_up.dart';
import 'package:belog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:belog/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseKey ?? '');
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (_) => AuthBloc(
              userSignUp: UserSignUp(AuthRepositoryImpl(
                  AuthRemoteDataSourceImpl(supabase.client)))))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ferdydurke',
      theme: AppTheme.darkThemeMode,
      home: const LoginPage(),
    );
  }
}
