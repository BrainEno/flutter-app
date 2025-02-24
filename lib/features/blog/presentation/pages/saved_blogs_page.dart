import 'package:belog/features/blog/presentation/bloc/bloc/blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedBlogsPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const SavedBlogsPage());
  const SavedBlogsPage({super.key});

  @override
  State<SavedBlogsPage> createState() => _SavedBlogsPageState();
}

class _SavedBlogsPageState extends State<SavedBlogsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的收藏'),
        elevation: 1.0, // Subtle shadow for depth
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: const Center(
            child: Text(
              '你还没有收藏文章',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
          // : GridView.builder(
          //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       crossAxisSpacing: 16.0,
          //       mainAxisSpacing: 16.0,
          //       childAspectRatio:
          //           0.75, // Adjusts the aspect ratio of each card
          //     ),
          //     itemCount: savedBlogs.length,
          //     itemBuilder: (context, index) {
          //       final blog = savedBlogs[index];
          //       return GestureDetector(
          //         onTap: () {
          //           // Navigate to the blog detail page
          //         },
          //         child: Card(
          //           elevation: 4.0,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(12.0),
          //           ),
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.circular(12.0),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: Text(
          //                     blog.title,
          //                     style: const TextStyle(
          //                       fontSize: 16.0,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                     maxLines: 2,
          //                     overflow: TextOverflow.ellipsis,
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding:
          //                       const EdgeInsets.symmetric(horizontal: 8.0),
          //                   child: Text(
          //                     blog.content.substring(1, 30),
          //                     style: const TextStyle(
          //                       fontSize: 14.0,
          //                       color: Colors.grey,
          //                     ),
          //                     maxLines: 2,
          //                     overflow: TextOverflow.ellipsis,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),

          ),
    );
  }
}
