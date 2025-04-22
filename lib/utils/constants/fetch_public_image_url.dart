import 'package:flutter_dotenv/flutter_dotenv.dart';

String getPublicImageUrl(String imagePath) {
  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  return '$supabaseUrl/storage/v1/object/public/images/$imagePath';
}
