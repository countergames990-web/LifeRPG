import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kReleaseMode;

class ImageCompressionService {
  // For local development, use localhost. For production, Netlify will use the deployed URL
  static const String _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:8888/.netlify/functions',
  );

  /// Check if Netlify functions are available
  static Future<bool> _isFunctionAvailable() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/upload-image'),
      ).timeout(const Duration(seconds: 2));
      return response.statusCode != 404;
    } catch (e) {
      return false;
    }
  }

  /// Compress and upload image to Netlify function
  /// Returns the compressed image URL (base64) or throws an exception
  static Future<String> compressImage(String base64Image, {String type = 'story'}) async {
    // In local development, check if function is available
    if (!kReleaseMode) {
      final isAvailable = await _isFunctionAvailable();
      if (!isAvailable) {
        throw Exception('Netlify function not available. Run "netlify dev" to test compression locally.');
      }
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/upload-image'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image': base64Image,
          'type': type, // 'character' or 'story'
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['imageUrl'] as String;
        } else {
          throw Exception('Image compression failed: ${data['error']}');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to compress image: $e');
    }
  }

  /// Check if the image size is within limits before compression
  static bool isImageSizeAcceptable(List<int> bytes) {
    const maxSize = 5 * 1024 * 1024; // 5MB before compression
    return bytes.length <= maxSize;
  }

  /// Get estimated compressed size (rough estimate)
  static int estimateCompressedSize(int originalSize, String type) {
    if (type == 'character') {
      // Character images are resized to 150x150, typically 20-40KB
      return 30 * 1024;
    } else {
      // Story images, typically 30-40% of original
      return (originalSize * 0.35).toInt();
    }
  }
}
