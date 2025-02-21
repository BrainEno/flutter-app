import 'package:belog/core/theme/app_pallete.dart';
import 'package:belog/core/utils/calculate_reading_time.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';
import 'package:belog/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        height: 200,
        margin: EdgeInsets.all(18).copyWith(bottom: 6),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
                image: NetworkImage(blog.imageUrl), fit: BoxFit.cover),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
              colors: [
                // Start color - light grey
                Colors.black.withAlpha(60),
                Colors.transparent,
                Colors.grey.withAlpha(70), // End color - stronger black
              ],
              stops: [0.0, 0.5, 1.0], // Control
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: blog.tags
                          .map((e) => Row(

                            children: [Chip(

                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  label: Text(
                                    e,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2),
                                  ),
                                ),
                                SizedBox(width:8)
                            ]
                          ))
                          .toList(),
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(blog.title,
                        style: TextStyle(
                            color: AppPallete.whiteColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            shadows: [
                              Shadow(
                                  color:
                                      Colors.black.withValues().withAlpha(50),
                                  offset: Offset(2, 2),
                                  blurRadius: 4)
                            ])),
                    Text(
                      blog.posterName!,
                      style: TextStyle(
                          letterSpacing: 0.2,
                          color: AppPallete.whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                                color: Colors.black.withValues().withAlpha(50),
                                offset: Offset(1, 1),
                                blurRadius: 1)
                          ]),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  calculateReadingTime(blog.content),
                ),
                Text(
                  blog.updatedAt.toString().substring(0, 10),
                  style: TextStyle(shadows: [
                    Shadow(
                        color: Colors.black.withValues().withAlpha(50),
                        offset: Offset(1, 1),
                        blurRadius: 2)
                  ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
