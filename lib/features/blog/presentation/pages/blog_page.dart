import 'package:belog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:belog/core/common/widgets/loader.dart';
import 'package:belog/core/utils/show_snackbar.dart';
import 'package:belog/features/blog/presentation/bloc/bloc/blog_bloc.dart';
import 'package:belog/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:belog/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const BlogPage());

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bottom Think'),
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Loader();
            } else if (state is BlogLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<BlogBloc>().add(BlogFetchAllBlogs());
                  await context
                      .read<BlogBloc>()
                      .stream
                      .firstWhere((newState) => newState is! BlogLoading);
                },
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 30),
                    itemCount: state.blogs.length,
                    itemBuilder: (context, index) {
                      final blog = state.blogs[index];
                      return BlogCard(blog: blog);
                    }),
              );
            } else if (state is BlogFailure) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return const Center(
              child: Text('暂时还没有文章...'),
            );
          },
        ),
        floatingActionButton: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is AppUserLoggedIn;
          },
          builder: (context, isLoggedIn) {
            return isLoggedIn
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context, AddNewBlogPage.route());
                    },
                    child: const Icon(CupertinoIcons.add),
                  )
                : const SizedBox();
          },
        ));
  }
}
