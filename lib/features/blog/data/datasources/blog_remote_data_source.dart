import 'dart:io';

import 'package:belog/core/error/exceptions.dart';
import 'package:belog/core/utils/retry_on_connection_closed.dart';
import 'package:belog/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blog});

  Future<List<BlogModel>> getAllBlogs();
  Future<BlogModel> getBlogById(String blogId);
  Future<List<BlogModel>> getBlogsByPosterId(String posterId);
  Future<List<BlogModel>> getBlogsByTag(String tag);
  Future<List<BlogModel>> searchBlogs(String query);
  Future<BlogModel> editBlog(BlogModel blog);
  Future<void> deleteBlog(String blogId);
  Future<List<BlogModel>> getUserLikedBlogs(String userId);
  Future<bool> toggleLikeBlog(String userId, String blogId);
  Future<bool> isBlogLikedByUser(String userId, String blogId);
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  const BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromJson(blogData[0]);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blog}) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs = await retryOnConnectionClosed(() => supabaseClient
          .from('blogs')
          .select('*, profiles (name, avatar_url)'));
      return List<BlogModel>.from(blogs.map((blog) => BlogModel.fromJson(blog)
          .copyWith(
              posterName: blog['profiles']['name'],
              posterAvatar: blog['profiles']['avatar_url']))).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getBlogsByPosterId(String posterId) async {
    try {
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name, avatar_url)')
          .eq('poster_id', posterId);

      return List<BlogModel>.from(blogs.map((blog) => BlogModel.fromJson(blog)
          .copyWith(
              posterName: blog['profiles']['name'],
              posterAvatar: blog['profiles']['avatar_url']))).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getBlogsByTag(String tag) async {
    try {
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name, avatar_url)')
          .contains('tags', tag);

      return List<BlogModel>.from(blogs.map((blog) => BlogModel.fromJson(blog)
          .copyWith(
              posterName: blog['profiles']['name'],
              posterAvatar: blog['profiles']['avatar_url']))).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> searchBlogs(String query) async {
    try {
      // Clean and prepare the query
      final sanitizedQuery = query.trim();
      if (sanitizedQuery.isEmpty) {
        return [];
      }

      // Detect if the query contains Chinese characters
      final containsChinese =
          RegExp(r'[\u4E00-\u9FFF]').hasMatch(sanitizedQuery);

      final blogsQuery =
          supabaseClient.from('blogs').select('*, profiles (name, avatar_url)');

      final blogs = await (containsChinese
          ? blogsQuery
              // For Chinese: use ilike as primary search
              .ilike('title', '%$sanitizedQuery%')
              // Add text search as secondary (plain config for no stemming)
              .textSearch('title', "'$sanitizedQuery':*", config: 'simple')
          : blogsQuery
              // For non-Chinese: use text search with English config
              .textSearch('title', "'$sanitizedQuery':*", config: 'english')
              .ilike('title', '%$sanitizedQuery%'));

      return blogs
          .map((blog) => BlogModel.fromJson(blog).copyWith(
                posterName: blog['profiles']['name'],
                posterAvatar: blog['profiles']['avatar_url'],
              ))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    try {
      await supabaseClient.from('blogs').delete().eq('id', blogId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> editBlog(BlogModel blog) async {
    try {
      final blogUpdated = await supabaseClient
          .from('blogs')
          .update({
            'title': blog.title,
            'content': blog.content,
            'tags': blog.tags,
          })
          .eq('id', blog.id)
          .single();
      return BlogModel.fromJson(blogUpdated);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> getBlogById(String blogId) async {
    try {
      final blog =
          await supabaseClient.from('blogs').select().eq('id', blogId).single();
      return BlogModel.fromJson(blog);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getUserLikedBlogs(String userId) async {
    try {
      final likedBlogs = await retryOnConnectionClosed(() => supabaseClient
          .from('likes')
          .select('blog_id, blogs(*, profiles (name, avatar_url))')
          .eq('user_id', userId));

      return List<BlogModel>.from(likedBlogs.map((like) {
        final blogData = like['blogs'] as Map<String, dynamic>;
        return BlogModel.fromJson(blogData).copyWith(
          posterName: blogData['profiles']['name'],
          posterAvatar: blogData['profiles']['avatar_url'],
        );
      })).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> toggleLikeBlog(String userId, String blogId) async {
    try {
      // Check if the like already exists
      final existingLike = await isBlogLikedByUser(userId, blogId);

      if (!existingLike) {
        // Add like
        await supabaseClient
            .from('likes')
            .insert({'user_id': userId, 'blog_id': blogId});
      } else {
        // Remove like
        await supabaseClient
            .from('likes')
            .delete()
            .eq('user_id', userId)
            .eq('blog_id', blogId);
      }
      return true;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> isBlogLikedByUser(String userId, String blogId) async {
    try {
      final response = await supabaseClient
          .from('likes')
          .select()
          .eq('user_id', userId)
          .eq('blog_id', blogId)
          .maybeSingle();

      // Returns true if the like exists, false otherwise
      return response != null;
    } catch (e) {
      if (e is PostgrestException && e.code == 'PGRST116') {
        // 404-like error when no results found
        return false;
      }
      throw ServerException(e.toString());
    }
  }
}
