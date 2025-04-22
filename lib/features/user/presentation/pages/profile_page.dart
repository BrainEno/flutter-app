import 'package:belog/core/common/widgets/theme_toggle_button.dart';
import 'package:belog/features/user/presentation/pages/about_page.dart';
import 'package:belog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:belog/core/utils/show_snackbar.dart';
import 'package:belog/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:belog/features/auth/presentation/pages/login_page.dart';
import 'package:belog/features/blog/presentation/pages/user_blogs_page.dart';
import 'package:belog/features/user/presentation/pages/edit_user_info_page.dart';
import 'package:belog/features/user/presentation/pages/edit_account_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 55,
            ),
            const Text('个人中心'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ThemeToggleButton()],
            )
          ],
        ),
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
              final user = state.user;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: user.avatarUrl.isNotEmpty
                          ? CachedNetworkImageProvider(
                              '${user.avatarUrl}?v=${user.updatedAt.millisecondsSinceEpoch}')
                          : null,
                      child: user.avatarUrl.isEmpty
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(
                        user.website.isNotEmpty ? user.website : '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          IconData icon;
                          switch (index) {
                            case 0:
                              icon = Icons.edit;
                              break;
                            case 1:
                              icon = Icons.article;
                              break;
                            case 2:
                              icon = Icons.settings;
                              break;
                            case 3:
                              icon = Icons.info;
                              break;
                            case 4:
                              icon = Icons.logout;
                              break;
                            default:
                              icon = Icons.help;
                          }
                          return ListTile(
                            leading: Icon(icon, color: Colors.grey.shade700),
                            title: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              switch (index) {
                                case 0:
                                  Navigator.push(
                                    context,
                                    EditUserInfoPage.route(),
                                  );
                                  break;
                                case 1:
                                  Navigator.push(
                                    context,
                                    UserBlogsPage.route(),
                                  );
                                  break;
                                case 2:
                                  Navigator.push(
                                    context,
                                    EditAccountPage.route(),
                                  );
                                  break;
                                case 3:
                                  Navigator.push(
                                    context,
                                    AboutPage.route(),
                                  );
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
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '您还没有登录',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, LoginPage.route());
                      },
                      child: const Text('登录'),
                    ),
                  ],
                ),
              );
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
