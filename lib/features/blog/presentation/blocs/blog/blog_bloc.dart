import 'package:belog/core/usecase/usecase.dart';
import 'package:belog/features/blog/domain/entities/blog.dart';
import 'package:belog/features/blog/domain/usecase/get_all_blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required GetAllBlogs getAllBlogs,
  })  : _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
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
}
