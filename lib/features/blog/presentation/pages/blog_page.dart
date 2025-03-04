import 'package:belog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:belog/core/common/widgets/loader.dart';
import 'package:belog/core/utils/show_snackbar.dart';
import 'package:belog/features/blog/presentation/blocs/blog/blog_bloc.dart';
import 'package:belog/features/blog/presentation/blocs/bog_upload/bloc/blog_upload_bloc.dart';
import 'package:belog/features/blog/presentation/pages/blog_editor_page.dart';
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
          if (state is BlogListFailure) {
            showSnackBar(context, state.error);
          }
          if (state is BlogUploadSuccess || state is BlogDeleteSuccess) {
            // Trigger a refresh of the blog list
            context.read<BlogBloc>().add(BlogFetchAllBlogs());
          }
        },
        builder: (context, state) {
          if (state is BlogListLoading) {
            // If we have a previous BlogLoaded state, show it with a loading overlay
            if (state.previousState is BlogLoaded) {
              final previousBlogs = (state.previousState as BlogLoaded).blogs;
              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: _refreshBlogs,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 30),
                      itemCount: previousBlogs.length,
                      itemBuilder: (context, index) {
                        final blog = previousBlogs[index];
                        return BlogCard(blog: blog);
                      },
                    ),
                  ),
                  const Center(child: Loader()),
                ],
              );
            }
            return const Loader();
          } else if (state is BlogLoaded) {
            if (state.blogs.isEmpty) {
              return const Center(child: Text('暂时还没有文章...'));
            }
            return RefreshIndicator(
              onRefresh: _refreshBlogs,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 30),
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  final blog = state.blogs[index];
                  return BlogCard(blog: blog);
                },
              ),
            );
          } else if (state is BlogListFailure) {
            return Center(child: Text('加载错误: ${state.error}'));
          }
          // Handle initial state explicitly
          return const Center(child: Text('加载中，请稍候...'));
        },
      ),
      floatingActionButton: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) => state is AppUserLoggedIn,
        builder: (context, isLoggedIn) {
          return isLoggedIn
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context, BlogEditorPage.route());
                  },
                  child: const Icon(CupertinoIcons.add),
                )
              : const SizedBox();
        },
      ),
    );
  }

  Future<void> _refreshBlogs() async {
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
    await context.read<BlogBloc>().stream.firstWhere(
          (newState) => newState is BlogLoaded || newState is BlogListFailure,
        );
  }
}
