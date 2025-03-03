part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogFetchAllBlogs extends BlogEvent {}
