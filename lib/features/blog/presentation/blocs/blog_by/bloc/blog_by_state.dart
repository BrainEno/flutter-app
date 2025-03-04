part of 'blog_by_bloc.dart';

@immutable
sealed class BlogByState {}

final class BlogByInitial extends BlogByState {}

final class GetBlogsByUserSuccess extends BlogByState {
  final List<Blog> blogs;

  GetBlogsByUserSuccess({required this.blogs});
}

final class GetBlogsByUserLoading extends BlogByState {}

final class GetBlogsByUserFailure extends BlogByState {
  final String error;

  GetBlogsByUserFailure({required this.error});
}
