import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' as Foundation;

class AppHelperFunctions {
  static bool get inReleaseMode => Foundation.kReleaseMode;

  static String normalizeImagePath(String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) return '';

    final trimmedPath = imagePath.trim();
    final parsedUri = Uri.tryParse(trimmedPath);

    if (parsedUri != null && parsedUri.scheme == 'http') {
      return parsedUri.replace(scheme: 'https').toString();
    }

    return trimmedPath;
  }

  static String getImageExtension(String? imagePath) {
    final normalizedPath = normalizeImagePath(imagePath);
    if (normalizedPath.isEmpty) return '';

    final sanitizedPath = normalizedPath.split('?').first.split('#').first;
    final parsedUri = Uri.tryParse(sanitizedPath);
    final resolvedPath = parsedUri?.path ?? sanitizedPath;
    final lastDotIndex = resolvedPath.lastIndexOf('.');

    if (lastDotIndex == -1 || lastDotIndex == resolvedPath.length - 1) {
      return '';
    }

    return resolvedPath.substring(lastDotIndex + 1).toLowerCase();
  }

  static bool isSvgImage(String? imagePath) =>
      getImageExtension(imagePath) == 'svg';

  static bool isNetworkImage(String? imagePath) {
    final normalizedPath = normalizeImagePath(imagePath);
    if (normalizedPath.isEmpty) return false;

    final parsedUri = Uri.tryParse(normalizedPath);
    return parsedUri != null &&
        (parsedUri.scheme == 'http' || parsedUri.scheme == 'https');
  }

  static Uint8List? extractEmbeddedImageBytesFromSvg(String svgContent) {
    final match = RegExp(
      r'(?:xlink:href|href)="data:image/[^;]+;base64,([^"]+)"',
      caseSensitive: false,
      dotAll: true,
    ).firstMatch(svgContent);

    if (match == null) return null;

    final base64Content = (match.group(1) ?? '').replaceAll(
      RegExp(r'\s+'),
      '',
    );

    if (base64Content.isEmpty) return null;

    try {
      return base64Decode(base64Content);
    } catch (_) {
      return null;
    }
  }
}
