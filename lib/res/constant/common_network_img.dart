
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';



class CommonNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? color;

  const CommonNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.color,
  });

  bool get _isNetwork {
    if (imageUrl == null) return false;
    return imageUrl!.startsWith("http") || imageUrl!.startsWith("https");
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return placeholder ??
          Icon(
            Icons.image_not_supported,
            size: width ?? height ?? 24,
            color: color ?? Colors.grey,
          );
    }

    if (_isNetwork) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        height: height,
        width: width,
        fit: fit,
        color: color,
        placeholder: (_, __) => placeholder ??
            SizedBox(
              height: height,
              width: width,

              // child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
        errorWidget: (_, __, ___) => errorWidget ??
            Icon(
              Icons.broken_image,
              size: width ?? height ?? 24,
              color: color ?? Colors.red,
            ),
      );
    }

    // Asset image fallback
    return Image.asset(
      imageUrl!,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (_, __, ___) => errorWidget ??
          Icon(
            Icons.broken_image,
            size: width ?? height ?? 24,
            color: color ?? Colors.red,
          ),
    );
  }
}
