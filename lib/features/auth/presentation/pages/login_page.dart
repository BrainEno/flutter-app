import 'package:belog/core/theme/app_pallete.dart';
import 'package:belog/features/auth/presentation/pages/signup_page.dart';
import 'package:belog/features/auth/presentation/widgets/auth_field.dart';
import 'package:belog/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '登录',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AuthField(
                    hintText: "邮箱",
                    controller: emailController,
                  ),
                  const SizedBox(height: 15),
                  AuthField(
                    hintText: "密码",
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  const SizedBox(height: 20),
                  AuthGradientButton(
                      buttonText: '登录',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          print('Login');
                        }
                      }),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.push(context, SignUpPage.route()),
                    child: RichText(
                      text: TextSpan(
                        text: "没有账号？",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: '注册',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: AppPallete.gradient2,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
