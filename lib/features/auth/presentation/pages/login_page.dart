import 'package:belog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:belog/core/common/entities/destination.dart';
import 'package:belog/core/common/widgets/loader.dart';
import 'package:belog/core/theme/app_pallete.dart';
import 'package:belog/core/utils/show_snackbar.dart';
import 'package:belog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:belog/features/auth/presentation/pages/signup_page.dart';
import 'package:belog/features/auth/presentation/widgets/auth_field.dart';
import 'package:belog/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:belog/features/blog/presentation/pages/blog_page.dart';
import 'package:belog/features/blog/presentation/pages/saved_blogs_page.dart';
import 'package:belog/features/blog/presentation/pages/search_blog_page.dart';
import 'package:belog/features/user/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  final Destination? destination;
  const LoginPage({super.key, this.destination});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark; // Check for dark mode

    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is AppUserLoggedIn && widget.destination != null) {
          switch (widget.destination!.index) {
            case 0:
              Navigator.pushReplacement(context, BlogPage.route());
              break;
            case 1:
              Navigator.pushReplacement(context, SearchBlogPage.route());
              break;
            case 2:
              Navigator.pushReplacement(context, SavedBlogsPage.route());
              break;
            case 3:
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()));
              break;
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode
              ? AppPallete.blackColor
              : Colors.white, // Dark AppBar background in dark mode
          elevation: 0,
          iconTheme: IconThemeData(
              color: isDarkMode
                  ? Colors.white
                  : Colors.black), // Light back arrow in dark mode
        ),
        backgroundColor: isDarkMode
            ? AppPallete.blackColor
            : Colors.white, // Dark background for Scaffold in dark mode
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  showSnackBar(context, state.message);
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Loader();
                }
                return Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      Text(
                        '登录',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.white
                              : Colors.black87, // Light title text in dark mode
                        ),
                      ),
                      const SizedBox(height: 40),
                      AuthField(
                        hintText: "邮箱",
                        controller: emailController,
                        prefixIcon: Icons.email_outlined,
                        style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode
                                ? Colors.white
                                : Colors
                                    .black87), // Light input text in dark mode
                        hintStyle: TextStyle(
                            fontSize: 16,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[
                                    600]), // Lighter hint text in dark mode
                        borderColor: isDarkMode
                            ? Colors.grey[700]
                            : Colors.grey[400], // Darker border in dark mode
                        focusedBorderColor: AppPallete.gradient2,
                      ),
                      const SizedBox(height: 20),
                      AuthField(
                        hintText: "密码",
                        controller: passwordController,
                        isObscureText: true,
                        prefixIcon: Icons.lock_outline,
                        style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode
                                ? Colors.white
                                : Colors
                                    .black87), // Light input text in dark mode
                        hintStyle: TextStyle(
                            fontSize: 16,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[
                                    600]), // Lighter hint text in dark mode
                        borderColor: isDarkMode
                            ? Colors.grey[700]
                            : Colors.grey[400], // Darker border in dark mode
                        focusedBorderColor: AppPallete.gradient2,
                      ),
                      const SizedBox(height: 30),
                      AuthGradientButton(
                          buttonText: "登录",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(AuthLogin(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim()));
                            }
                          }),
                      const SizedBox(height: 30),
                      Center(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.push(context, SignUpPage.route()),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "没有账号？",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[
                                          700]), // Lighter "No account?" text in dark mode
                              children: [
                                TextSpan(
                                  text: '注册',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppPallete.gradient2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
