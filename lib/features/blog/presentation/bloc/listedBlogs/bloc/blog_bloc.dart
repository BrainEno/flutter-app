import 'dart:io';

import 'package:belog/core/usecase/usecase.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';
import 'package:belog/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:belog/features/blog/domain/usecase/search_blogs.dart';
import 'package:belog/features/blog/domain/usecase/upload_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final SearchBlogs _searchBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
    required SearchBlogs searchBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _searchBlogs = searchBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogListLoading());
    });
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<BlogSearchBlogs>(_onSearchBlogs);
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
      (failure) => emit(BlogUploadFailure(error: failure.message)),
      (blog) => emit(BlogUploadSuccess()),
    );
  }

  void _onFetchAllBlogs(
      BlogFetchAllBlogs event, Emitter<BlogState> emit) async {
    emit(BlogListLoading());
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (failure) => emit(BlogListFailure(error: failure.message)),
      (blogs) => emit(BlogLoaded(blogs: blogs)),
    );
  }

  void _onSearchBlogs(BlogSearchBlogs event, Emitter<BlogState> emit) async {
    emit(BlogSearchLoading());
    final res = await _searchBlogs(SearchBlogsParams(query: event.query));

    res.fold(
      (failure) => emit(BlogSearchFailure(error: failure.message)),
      (blogs) => emit(BlogSearchSuccess(blogs: blogs)),
    );
  }
}
