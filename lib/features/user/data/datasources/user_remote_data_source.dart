import 'dart:io';

import 'package:belog/core/error/exceptions.dart';
import 'package:belog/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class UserRemoteDataSource {
  Future<String> uploadAvatar({required File image, required String userId});
  Future<UserModel> editUser(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient supabaseClient;
  UserRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<String> uploadAvatar(
      {required File image, required String userId}) async {
    try {
      await supabaseClient.storage.from('avatars').upload(userId, image);
      return supabaseClient.storage.from('avatars').getPublicUrl(userId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> editUser(UserModel user) async {
    try {
      final userUpdated = await supabaseClient
          .from('profiles')
          .update({'name': user.name, 'email': user.email})
          .eq('id', user.id)
          .single();
      return UserModel.fromJson(userUpdated);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
