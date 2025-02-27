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

final class BlogUploadSuccess extends BlogState {}

final class BlogUploadFailure extends BlogState {
  final String error;

  BlogUploadFailure({required this.error});
}

final class BlogUploadLoading extends BlogState {}

final class BlogLoaded extends BlogState {
  final List<Blog> blogs;
  BlogLoaded({required this.blogs, super.previousState});
}

final class BlogSearchSuccess extends BlogState {
  final List<Blog> blogs;
  BlogSearchSuccess({required this.blogs});
}

final class BlogSearchFailure extends BlogState {
  final String error;
  BlogSearchFailure({required this.error});
}

final class BlogSearchLoading extends BlogState {}
