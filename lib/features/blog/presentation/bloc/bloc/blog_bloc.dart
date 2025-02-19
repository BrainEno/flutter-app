import 'dart:io';

import 'package:belog/core/usecase/usecase.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';
import 'package:belog/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:belog/features/blog/domain/usecase/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
      : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(UploadBlogParams(
      image: event.image,
      title: event.title,
      content: event.content,
      posterId: event.posterId,
      tags: event.tags,
    ));

    res.fold(
      (failure) => emit(BlogFailure(error: failure.message)),
      (blog) => emit(BlogSuccess()),
    );
  }

  void _onFetchAllBlogs(
      BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (failure) => emit(BlogFailure(error: failure.message)),
      (blogs) => emit(BlogLoaded(blogs: blogs)),
    );
  }
}
