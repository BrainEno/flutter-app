part of 'blog_liked_bloc.dart';

@immutable
sealed class BlogLikedState {
  final Map<String, bool> likedBlogs; // Track like status by blogId
  const BlogLikedState({this.likedBlogs = const {}});
}

final class BlogLikedInitial extends BlogLikedState {}

final class UserLikedBlogsLoading extends BlogLikedState {
  const UserLikedBlogsLoading({super.likedBlogs});
}

final class UserLikedBlogsSuccess extends BlogLikedState {
  final List<Blog> blogs;
  const UserLikedBlogsSuccess({required this.blogs, super.likedBlogs});
}

final class UserLikedBlogsFailure extends BlogLikedState {
  final String error;
  const UserLikedBlogsFailure({required this.error, super.likedBlogs});
}

final class ToggleBlogLikeSuccess extends BlogLikedState {
  final String blogId;
  final bool isLiked;
  const ToggleBlogLikeSuccess(
      {required this.blogId, required this.isLiked, super.likedBlogs});
}

final class ToggleBlogLikeFailure extends BlogLikedState {
  final String error;
  const ToggleBlogLikeFailure({required this.error, super.likedBlogs});
}

final class GetBlogIsLikedSuccess extends BlogLikedState {
  final String blogId;
  final bool isLiked;
  const GetBlogIsLikedSuccess(
      {required this.blogId, required this.isLiked, super.likedBlogs});
}

final class GetBlogIsLikedFailure extends BlogLikedState {
  final String error;
  const GetBlogIsLikedFailure({required this.error, super.likedBlogs});
}
