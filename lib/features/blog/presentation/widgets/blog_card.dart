import 'package:belog/core/theme/app_pallete.dart';
import 'package:belog/core/utils/calculate_reading_time.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  const BlogCard({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
              image: NetworkImage(blog.imageUrl), fit: BoxFit.cover)),
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
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Chip(
                                label: Text(e),
                              ),
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
                                color: Colors.black.withValues().withAlpha(50),
                                offset: Offset(2, 2),
                                blurRadius: 4)
                          ])),
                  Text(
                    blog.posterName!,
                    style: TextStyle(
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
                style: TextStyle(shadows: [
                  Shadow(
                      color: Colors.black.withValues().withAlpha(50),
                      offset: Offset(1, 1),
                      blurRadius: 2)
                ]),
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
    );
  }
}
