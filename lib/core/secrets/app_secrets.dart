import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSecrets {
  static String? supabaseUrl = dotenv.env['SUPABASE_URL'];
  static String? supabaseKey = dotenv.env['SUPABASE_KEY'];
}
