part of 'blog_upload_bloc.dart';

abstract class BlogUploadState {}

class BlogUploadInitial extends BlogUploadState {}

class BlogUploadLoading extends BlogUploadState {}

class BlogUploadSuccess extends BlogUploadState {}

class BlogUploadFailure extends BlogUploadState {
  final String error;
  BlogUploadFailure({required this.error});
}
