part of 'blog_bloc.dart';

sealed class BlogState {
  final BlogState? previousState;
  BlogState({this.previousState});
}

final class BlogInitial extends BlogState {
  BlogInitial() : super(previousState: null);
}

final class BlogListLoading extends BlogState {
  BlogListLoading({super.previousState});
}

final class BlogListFailure extends BlogState {
  final String error;
  BlogListFailure({required this.error, super.previousState});
}

final class BlogLoaded extends BlogState {
  final List<Blog> blogs;
  BlogLoaded({required this.blogs, super.previousState});
}
