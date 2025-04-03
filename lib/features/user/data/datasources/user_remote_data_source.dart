import 'dart:io';

import 'package:belog/core/error/exceptions.dart';
import 'package:belog/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class UserRemoteDataSource {
  Future<UserModel> getUserById(String userId);
  Future<String> uploadAvatar({required File image, required String userId});
  Future<UserModel> editUserInfo(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient supabaseClient;
  UserRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<String> uploadAvatar(
      {required File image, required String userId}) async {
    try {
      await supabaseClient.storage
          .from('avatars')
          .upload(userId, image, fileOptions: FileOptions(upsert: true));
      return supabaseClient.storage.from('avatars').getPublicUrl(userId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> editUserInfo(UserModel user) async {
    try {
      final userUpdated = await supabaseClient
          .from('profiles')
          .update(user.toJson())
          .eq('id', user.id)
          .select()
          .single();
      return UserModel.fromJson(userUpdated);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> getUserById(String userId) async {
    try {
      final res = await supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      // ignore: unnecessary_null_comparison
      if (res == null) {
        throw ServerException('Blog with ID $userId not found');
      }

      return UserModel.fromJson(res);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
