import '../app_data/app_globals.dart';

String getAbsoluteImageUrl(String imageUrl) {
  if (imageUrl.isEmpty) {
    return '';
  }

  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
    return imageUrl;
  }

  if (imageUrl.startsWith('/')) {
    return '$backendUrl$imageUrl';
  }

  return imageUrl;
}
