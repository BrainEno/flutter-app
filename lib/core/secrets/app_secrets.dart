import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSecrets {
  static const supabaseUrl = 'https://xbnpsnktdcdhlqrcidio.supabase.co';
  static String? supabaseKey = dotenv.env['SUPABASE_KEY'];
}
