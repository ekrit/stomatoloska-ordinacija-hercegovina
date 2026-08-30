import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_providers.dart';
import '../config/app_config.dart';

/// Loads an image from an authenticated API endpoint.
///
/// List endpoints no longer return picture bytes with every row — a page of
/// results would otherwise carry several megabytes of images that a thumbnail
/// immediately downscales. Rows carry a `hasPicture` flag and the bytes are
/// fetched here, per image, which also lets the HTTP layer cache them per id
/// instead of re-sending them with every listing.
///
/// Renders [placeholder] when there is no image or the request fails.
class RemoteImage extends ConsumerWidget {
  const RemoteImage({
    super.key,
    required this.path,
    required this.hasImage,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  /// API path, e.g. `/Product/12/picture`.
  final String path;

  /// From the list row; false skips the request entirely.
  final bool hasImage;

  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fallback = placeholder ??
        Icon(Icons.image_not_supported_outlined,
            size: (width ?? height ?? 40) * 0.5,
            color: Theme.of(context).colorScheme.outline);

    if (!hasImage) {
      return SizedBox(width: width, height: height, child: Center(child: fallback));
    }

    final token = ref.watch(authTokenProvider);
    final base = AppConfig.apiBaseUrl.replaceAll(RegExp(r'/+$'), '');

    return Image.network(
      '$base$path',
      width: width,
      height: height,
      fit: fit,
      headers: token == null || token.isEmpty
          ? const {}
          : {'Authorization': 'Bearer $token'},
      errorBuilder: (context, _, __) =>
          SizedBox(width: width, height: height, child: Center(child: fallback)),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      },
    );
  }
}
