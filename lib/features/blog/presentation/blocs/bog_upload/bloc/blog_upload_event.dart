part of 'blog_upload_bloc.dart';

abstract class BlogUploadEvent {
  final File image;
  final String title;
  final String content;
  final String posterId;
  final List<String> tags;

  BlogUploadEvent({
    required this.image,
    required this.title,
    required this.content,
    required this.posterId,
    required this.tags,
  });
}

class UploadBlogEvent extends BlogUploadEvent {
  UploadBlogEvent({
    required super.image,
    required super.title,
    required super.content,
    required super.posterId,
    required super.tags,
  });
}
