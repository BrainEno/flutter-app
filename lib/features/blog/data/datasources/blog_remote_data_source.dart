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
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name, avatar_url)')
          .textSearch('title', query);
      return List<BlogModel>.from(blogs.map((blog) => BlogModel.fromJson(blog)
          .copyWith(
              posterName: blog['profiles']['name'],
              posterAvatar: blog['profiles']['avatar_url']))).toList();
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
}
