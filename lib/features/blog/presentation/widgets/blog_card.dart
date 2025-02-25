import 'package:flutter/material.dart';
import 'package:belog/core/theme/app_pallete.dart';
import 'package:belog/core/utils/calculate_reading_time.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';
import 'package:belog/features/blog/presentation/pages/blog_viewer_page.dart';

class BlogCard extends StatefulWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getTagColor(String tag) {
    // You can expand this logic based on your tag types or categories
    switch (tag.toLowerCase()) {
      case '诗歌':
        return const Color.fromRGBO(255, 59, 48, 100);
      case '小说':
        return Color.fromRGBO(0, 113, 164, 100);
      case '原创':
        return Color.fromRGBO(175, 82, 222, 100);
      default:
        return const Color.fromRGBO(255, 179, 64, 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(widget.blog));
      },
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 210,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 8,
                    offset: const Offset(0, 6),
                  ),
                ],
                image: DecorationImage(
                  image: NetworkImage(widget.blog.imageUrl),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(50),
                    Colors.black87,
                  ],
                  stops: [0.3, 0.7, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tags Section
                    if (widget.blog.tags.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: widget.blog.tags
                              .map((tag) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    child: Chip(
                                      label: Text(
                                        tag,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      backgroundColor:
                                          _getTagColor(tag).withAlpha(220),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        side: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    const Spacer(), // Pushes content to the bottom

                    // Title and Author Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.blog.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppPallete.whiteColor,
                            fontSize: 26, // Larger title for emphasis
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black87,
                                offset: Offset(1, 1),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (widget.blog.posterName != null)
                          Text(
                            widget.blog.posterName!,
                            style: const TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 0.95),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Metadata Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          calculateReadingTime(widget.blog.content),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.blog.updatedAt.toString().substring(0, 10),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
