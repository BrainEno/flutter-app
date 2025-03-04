import 'package:belog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:belog/core/utils/show_snackbar.dart';
import 'package:belog/features/blog/presentation/blocs/blog_by/bloc/blog_by_bloc.dart';
import 'package:belog/features/blog/presentation/blocs/bog_upload/bloc/blog_upload_bloc.dart';
import 'package:belog/features/blog/presentation/pages/blog_editor_page.dart';
import 'package:belog/features/blog/presentation/widgets/blog_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBlogsPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const UserBlogsPage());
  const UserBlogsPage({super.key});

  @override
  State<UserBlogsPage> createState() => _UserBlogsPageState();
}

class _UserBlogsPageState extends State<UserBlogsPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchUserBlogs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchUserBlogs();
    }
  }

  void _fetchUserBlogs() {
    final appUserState = context.read<AppUserCubit>().state;
    if (appUserState is AppUserLoggedIn) {
      final userId = appUserState.user.id;
      context.read<BlogByBloc>().add(GetBlogByPosterEvent(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的文章'),
        centerTitle: true,
      ),
      body: BlocListener<BlogUploadBloc, BlogUploadState>(
        listener: (context, state) {
          if (state is BlogUploadSuccess || state is BlogDeleteSuccess) {
            _fetchUserBlogs();
          }
        },
        child: BlocConsumer<BlogByBloc, BlogByState>(
          listener: (context, state) {
            if (state is GetBlogsByUserFailure) {
              showSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is GetBlogsByUserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetBlogsByUserSuccess) {
              final blogs = state.blogs;
              if (blogs.isEmpty) {
                return const Center(child: Text('您还没有发布任何文章'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  _fetchUserBlogs();
                  await context.read<BlogByBloc>().stream.firstWhere(
                        (newState) =>
                            newState is GetBlogsByUserSuccess ||
                            newState is GetBlogsByUserFailure,
                      );
                },
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    final blog = blogs[index];
                    return BlogGridItem(
                      blog: blog,
                      onTap: () {
                        Navigator.push(
                            context, BlogEditorPage.route(blog: blog));
                      },
                    );
                  },
                ),
              );
            }
            return const Center(child: Text('无法加载文章'));
          },
        ),
      ),
    );
  }
}
