import '../app_data/app_globals.dart';

/// Converts relative image URLs to absolute URLs using the backend base URL
String getAbsoluteImageUrl(String imageUrl) {
  if (imageUrl.isEmpty) {
    return '';
  }

  // If URL is already absolute (starts with http/https), return as-is
  if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
    return imageUrl;
  }

  // If URL is relative (starts with /), prepend backend URL
  if (imageUrl.startsWith('/')) {
    return '$backendUrl$imageUrl';
  }

  // Default case: return as-is
  return imageUrl;
}
