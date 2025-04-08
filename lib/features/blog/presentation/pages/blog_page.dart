import 'package:belog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:belog/core/common/widgets/loader.dart';
import 'package:belog/core/utils/show_snackbar.dart';
import 'package:belog/features/blog/presentation/blocs/blog/blog_bloc.dart';
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

class _BlogPageState extends State<BlogPage> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;
  int _page = 1; // Pagination page number
  List<dynamic> _blogs = []; // Store all loaded blogs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchBlogs(); // Initial fetch
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchBlogs(refresh: true); // Refresh when returning to the page
    }
  }

  void _fetchBlogs({bool refresh = false}) {
    final blogBloc = context.read<BlogBloc>();
    if (refresh) {
      _page = 1; // Reset to first page for refresh
      _blogs.clear(); // Clear existing blogs on refresh
      blogBloc.add(BlogFetchAllBlogs(page: _page, refresh: true));
    } else {
      blogBloc.add(BlogFetchAllBlogs(page: _page));
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetchingMore) {
      _fetchMoreBlogs();
    }
  }

  void _fetchMoreBlogs() {
    setState(() => _isFetchingMore = true);
    _page++;
    context.read<BlogBloc>().add(BlogFetchAllBlogs(page: _page));
  }

  Future<void> _refreshBlogs() async {
    _fetchBlogs(refresh: true);
    await context.read<BlogBloc>().stream.firstWhere(
          (state) => state is BlogLoaded || state is BlogListFailure,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage('assets/images/icon.png'),
              size: 30,
            ),
            SizedBox(
              width: 7,
            ),
            const Text('Bottom Think'),
          ],
        ),
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogListFailure) {
            showSnackBar(context, state.error);
            setState(() => _isFetchingMore = false); // Reset on failure
          }
          if (state is BlogLoaded) {
            if (state.blogs.isNotEmpty || _page == 1) {
              setState(() {
                if (_page == 1) {
                  _blogs = state.blogs; // Replace on refresh or initial load
                } else {
                  _blogs.addAll(state.blogs); // Append for pagination
                }
                _isFetchingMore = false; // Reset fetching flag
              });
            } else {
              // No new blogs, keep existing ones, reset fetching
              setState(() => _isFetchingMore = false);
            }
          }
        },
        builder: (context, state) {
          if (state is BlogListLoading && state.previousState == null) {
            return const Loader(); // Initial load
          }

          // Always show blogs if we have them, even during loading
          if (_blogs.isEmpty && state is BlogLoaded) {
            return RefreshIndicator(
              onRefresh: _refreshBlogs,
              child: const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshBlogs,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 8, bottom: 30),
              itemCount: _blogs.length + (_isFetchingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _blogs.length && _isFetchingMore) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                  );
                }
                final blog = _blogs[index];
                return BlogCard(blog: blog);
              },
            ),
          );
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
}
