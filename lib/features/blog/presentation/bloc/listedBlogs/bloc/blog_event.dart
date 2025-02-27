part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUpload extends BlogEvent {
  final File image;
  final String title;
  final String content;
  final String posterId;
  final List<String> tags;

  BlogUpload({
    required this.image,
    required this.title,
    required this.content,
    required this.posterId,
    required this.tags,
  });
}

final class BlogFetchAllBlogs extends BlogEvent {}

final class BlogSearchBlogs extends BlogEvent {
  final String query;

  BlogSearchBlogs({required this.query});
}
