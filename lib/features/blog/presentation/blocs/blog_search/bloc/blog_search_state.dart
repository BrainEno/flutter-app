part of 'blog_search_bloc.dart';

abstract class BlogSearchState {}

class BlogSearchInitial extends BlogSearchState {}

class BlogSearchLoading extends BlogSearchState {}

class BlogSearchSuccess extends BlogSearchState {
  final List<Blog> blogs;
  BlogSearchSuccess({required this.blogs});
}

class BlogSearchFailure extends BlogSearchState {
  final String error;
  BlogSearchFailure({required this.error});
}
