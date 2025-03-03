import 'dart:io';
import 'package:belog/features/blog/domain/usecase/upload_blog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_upload_event.dart';
part 'blog_upload_state.dart';

class BlogUploadBloc extends Bloc<BlogUploadEvent, BlogUploadState> {
  final UploadBlog _uploadBlog;

  BlogUploadBloc({required UploadBlog uploadBlog})
      : _uploadBlog = uploadBlog,
        super(BlogUploadInitial()) {
    on<UploadBlogEvent>(_onUploadBlog);
  }

  void _onUploadBlog(
      UploadBlogEvent event, Emitter<BlogUploadState> emit) async {
    emit(BlogUploadLoading());
    final res = await _uploadBlog(UploadBlogParams(
      image: event.image,
      title: event.title,
      content: event.content,
      posterId: event.posterId,
      tags: event.tags,
    ));

    res.fold(
      (failure) => emit(BlogUploadFailure(error: failure.message)),
      (blog) => emit(BlogUploadSuccess()),
    );
  }
}
