import 'package:belog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:belog/core/common/entities/destination.dart';
import 'package:belog/features/auth/presentation/pages/login_page.dart';
import 'package:belog/features/blog/presentation/pages/blog_page.dart';
import 'package:belog/features/blog/presentation/pages/saved_blogs_page.dart';
import 'package:belog/features/blog/presentation/pages/search_blog_page.dart';
import 'package:belog/features/user/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DestinationView extends StatefulWidget {
  const DestinationView({
    super.key,
    required this.destination,
    required this.navigatorKey,
  });

  final Destination destination;
  final Key navigatorKey;

  @override
  State<DestinationView> createState() => _DestinationViewState();
}

class _DestinationViewState extends State<DestinationView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        // Check if user is not logged in and the destination requires authentication
        if (state is! AppUserLoggedIn &&
            (widget.destination.index == 2 || widget.destination.index == 3)) {
          (widget.navigatorKey as GlobalKey<NavigatorState>)
              .currentState!
              .pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      LoginPage(destination: widget.destination),
                ),
              );
        }
      },
      child: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) => state is AppUserLoggedIn,
        builder: (context, isLoggedIn) {
          return Navigator(
            key: widget.navigatorKey as GlobalKey<NavigatorState>,
            onGenerateRoute: (RouteSettings settings) {
              return MaterialPageRoute<void>(
                settings: settings,
                builder: (BuildContext context) {
                  switch (widget.destination.index) {
                    case 0:
                      return const BlogPage();
                    case 1:
                      return const SearchBlogPage();
                    case 2:
                      return isLoggedIn
                          ? const SavedBlogsPage()
                          : LoginPage(destination: widget.destination);
                    case 3:
                      return isLoggedIn
                          ? const ProfilePage()
                          : LoginPage(
                              destination: widget.destination,
                            );
                    default:
                      return const BlogPage();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
