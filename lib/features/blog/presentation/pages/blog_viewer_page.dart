import 'package:belog/core/theme/app_pallete.dart';
import 'package:belog/core/utils/calculate_reading_time.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  final Blog blog;
  static route(Blog blog) => MaterialPageRoute(
      builder: (context) => BlogViewerPage(
            blog: blog,
          ));
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Column(
            children: [
              Container(
                  height: 200,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          image: NetworkImage(blog.imageUrl),
                          fit: BoxFit.cover))),
              Row(
                children: [
                  blog.posterAvatar != null
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(blog.posterAvatar ?? ''),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person),
                        ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        blog.posterName!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            letterSpacing: 0.2),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            blog.updatedAt.toString().substring(0, 10),
                            style: TextStyle(color: AppPallete.greyColor),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(color: AppPallete.greyColor),
                          ),
                          Text(
                            calculateReadingTime(blog.content),
                            style: TextStyle(color: AppPallete.greyColor),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                blog.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                blog.content,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  letterSpacing: 1.7,
                  height: 1.6,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: blog.tags
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "# $e",
                            style: const TextStyle(
                                color: AppPallete.gradient1,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
