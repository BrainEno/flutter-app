import 'package:belog/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:belog/core/theme/app_pallete.dart';
import 'package:belog/core/utils/calculate_reading_time.dart';
import 'package:belog/core/utils/show_snackbar.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';
import 'package:belog/features/blog/presentation/blocs/blog_liked/blog_liked_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogViewerPage extends StatefulWidget {
  final Blog blog;
  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(blog: blog),
      );
  const BlogViewerPage({super.key, required this.blog});

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  @override
  void initState() {
    super.initState();
    _checkIfIsLiked();
  }

  void _checkIfIsLiked() {
    final appUserState = context.read<AppUserCubit>().state;

    if (appUserState is AppUserLoggedIn) {
      final userId = appUserState.user.id;

      context
          .read<BlogLikedBloc>()
          .add(GetIsBlogLiked(userId: userId, blogId: widget.blog.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            centerTitle:true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(16),
              centerTitle:true,
              title: Text(
                widget.blog.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black87,
                      offset: Offset(1, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.blog.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withAlpha((0.3 * 255).toInt()),
                          Colors.black.withAlpha((0.7 * 255).toInt()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              BlocConsumer<BlogLikedBloc, BlogLikedState>(
                listener: (context, state) {
                  if (state is ToggleBlogLikeFailure) {
                    showSnackBar(context, state.error);
                  }
                },
                builder: (context, state) {
                  // Use likedBlogs map to determine if the blog is saved
                  bool isSaved = state.likedBlogs[widget.blog.id] ?? false;
                  return IconButton(
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        final appUserState = context.read<AppUserCubit>().state;
                        if (appUserState is AppUserLoggedIn) {
                          final userId = appUserState.user.id;
                          context.read<BlogLikedBloc>().add(ToggleBlogLike(
                              userId: userId, blogId: widget.blog.id));
                        } else {
                          showSnackBar(context, '请先登录账户');
                        }
                      });
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: widget.blog.posterAvatar != null
                            ? CachedNetworkImageProvider(
                                widget.blog.posterAvatar!)
                            : null,
                        child: widget.blog.posterAvatar == null
                            ? const Icon(Icons.person, size: 20)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.blog.posterName ?? 'Unknown Author',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                widget.blog.updatedAt
                                    .toString()
                                    .substring(0, 10),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.access_time,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                calculateReadingTime(widget.blog.content),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.blog.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.blog.tags
                        .map((tag) => Chip(
                              label: Text(
                                tag,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppPallete.gradient1,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5),
                              ),
                              backgroundColor:
                                  Colors.grey.withAlpha((0.1 * 255).toInt()),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
