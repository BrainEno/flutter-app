part of 'blog_upload_bloc.dart';

abstract class BlogUploadEvent extends Equatable {
  const BlogUploadEvent();
}

class UploadBlogEvent extends BlogUploadEvent {
  final File image;
  final String title;
  final String content;
  final String posterId;
  final List<String> tags;

  const UploadBlogEvent({
    required this.image,
    required this.title,
    required this.content,
    required this.posterId,
    required this.tags,
  });

  @override
  List<Object> get props => [image, title, content, posterId, tags];
}

class UpdateBlogEvent extends BlogUploadEvent {
  final String blogId;
  final File? image; // Optional, only if updating image
  final String title;
  final String content;
  final List<String> tags;

  const UpdateBlogEvent({
    required this.blogId,
    this.image,
    required this.title,
    required this.content,
    required this.tags,
  });

  @override
  List<Object?> get props => [blogId, image, title, content, tags];
}

class DeleteBlogEvent extends BlogUploadEvent {
  final String blogId;

  const DeleteBlogEvent({required this.blogId});

  @override
  List<Object> get props => [blogId];
}
