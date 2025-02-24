import 'package:belog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:belog/core/utils/show_snackbar.dart';
import 'package:belog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  static const List<String> items = <String>[
    '编辑个人资料',
    '我的文章',
    '账号设置',
    '关于我们',
    '退出登录',
  ];
  static route() => MaterialPageRoute(builder: (_) => const ProfilePage());
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人中心'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLogoutFailure) {
            showSnackBar(context, state.message);
          }
        },
        child: BlocBuilder<AppUserCubit, AppUserState>(
          builder: (context, state) {
            if (state is AppUserLoggedIn) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        state.user.avartarUrl.isNotEmpty
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    NetworkImage(state.user.avartarUrl),
                              )
                            : const CircleAvatar(child: Icon(Icons.person)),
                        const SizedBox(height: 10),
                        Text(state.user.name),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ListTile(
                            title: Text(item),
                            onTap: () {
                              switch (index) {
                                case 0:
                                  break;
                                case 1:
                                  break;
                                case 2:
                                  break;
                                case 3:
                                  break;
                                case 4:
                                  _onLogoutClick(context);
                                  break;
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('请先登录'));
            }
          },
        ),
      ),
    );
  }

  void _onLogoutClick(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogout());
  }
}
