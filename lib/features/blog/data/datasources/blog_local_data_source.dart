import 'package:belog/features/blog/data/models/blog_model.dart';
import 'package:isar/isar.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';

abstract interface class BlogLocalDataSource {
  Future<void> uploadLocalBlogs({required List<BlogModel> blogs});
  Future<List<BlogModel>> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Isar isar;

  BlogLocalDataSourceImpl({required this.isar});

  IsarCollection<Blog> get blogCollection => isar.blogs;

  @override
  Future<List<BlogModel>> loadBlogs() async {
    List<BlogModel> blogs = [];

    int len = blogCollection.countSync();

    for (int i = 0; i < len; i++) {
      final blog = await blogCollection.get(i);
      if (blog != null) {
        blogs.add(BlogModel(
            id: blog.id,
            title: blog.title,
            content: blog.content,
            posterId: blog.posterId,
            imageUrl: blog.imageUrl,
            tags: blog.tags,
            updatedAt: blog.updatedAt));
      }
    }

    return blogs;
  }

  @override
  Future<void> uploadLocalBlogs({required List<BlogModel> blogs}) async {
    await isar.writeTxn(() async {
      blogCollection.putAll(blogs);
    });
  }
}
