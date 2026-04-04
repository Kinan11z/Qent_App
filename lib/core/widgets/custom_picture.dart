import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qent_app/core/helper_functions/helper_functions.dart';
import 'package:qent_app/core/resources/app_colors.dart';

class CustomPicture extends StatelessWidget {
  const CustomPicture({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.package,
    this.color,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final String? package;
  final Color? color;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final resolvedImagePath = AppHelperFunctions.normalizeImagePath(imagePath);

    if (resolvedImagePath.isEmpty) {
      return _wrapWithClip(_buildErrorWidget());
    }

    final isSvg = AppHelperFunctions.isSvgImage(resolvedImagePath);
    final isNetwork = AppHelperFunctions.isNetworkImage(resolvedImagePath);

    if (isSvg) {
      return _wrapWithClip(
        isNetwork
            ? _NetworkSvgPicture(
                imagePath: resolvedImagePath,
                width: width,
                height: height,
                fit: fit,
                alignment: alignment,
                color: color,
                placeholder: placeholder,
                errorWidget: errorWidget,
              )
            : SvgPicture.asset(
                resolvedImagePath,
                width: width,
                height: height,
                fit: fit,
                alignment: alignment,
                package: package,
                colorFilter: color == null
                    ? null
                    : ColorFilter.mode(color!, BlendMode.srcIn),
                placeholderBuilder: (_) => placeholder ?? _buildPlaceholder(),
              ),
      );
    }

    if (isNetwork) {
      return _wrapWithClip(
        Image.network(
          resolvedImagePath,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          color: color,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return placeholder ?? _buildPlaceholder();
          },
          errorBuilder: (_, __, ___) => _buildErrorWidget(),
        ),
      );
    }

    return _wrapWithClip(
      Image.asset(
        resolvedImagePath,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        package: package,
        color: color,
        errorBuilder: (_, __, ___) => _buildErrorWidget(),
      ),
    );
  }

  Widget _wrapWithClip(Widget child) {
    if (borderRadius == null) return child;

    return ClipRRect(
      borderRadius: borderRadius!,
      child: child,
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.grayHintTextColor,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return errorWidget ??
        const Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: AppColors.grayHintTextColor,
          ),
        );
  }
}

class _NetworkSvgPicture extends StatefulWidget {
  const _NetworkSvgPicture({
    required this.imagePath,
    required this.width,
    required this.height,
    required this.fit,
    required this.alignment,
    required this.color,
    required this.placeholder,
    required this.errorWidget,
  });

  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final Color? color;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  State<_NetworkSvgPicture> createState() => _NetworkSvgPictureState();
}

class _NetworkSvgPictureState extends State<_NetworkSvgPicture> {
  late Future<_ResolvedNetworkSvg> _svgFuture;

  @override
  void initState() {
    super.initState();
    _svgFuture = _loadSvg(widget.imagePath);
  }

  @override
  void didUpdateWidget(covariant _NetworkSvgPicture oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.imagePath != widget.imagePath) {
      _svgFuture = _loadSvg(widget.imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ResolvedNetworkSvg>(
      future: _svgFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return widget.placeholder ?? const _DefaultPicturePlaceholder();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return widget.errorWidget ?? const _DefaultPictureError();
        }

        final data = snapshot.data!;

        if (data.embeddedImageBytes != null) {
          return Image.memory(
            data.embeddedImageBytes!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            alignment: widget.alignment,
            color: widget.color,
            errorBuilder: (_, __, ___) =>
                widget.errorWidget ?? const _DefaultPictureError(),
          );
        }

        return SvgPicture.string(
          data.svgContent,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          alignment: widget.alignment,
          colorFilter: widget.color == null
              ? null
              : ColorFilter.mode(widget.color!, BlendMode.srcIn),
          placeholderBuilder: (_) =>
              widget.placeholder ?? const _DefaultPicturePlaceholder(),
        );
      },
    );
  }

  Future<_ResolvedNetworkSvg> _loadSvg(String path) async {
    final bundle = NetworkAssetBundle(Uri.parse(path));
    final svgContent = await bundle.loadString(path);
    final embeddedImageBytes =
        AppHelperFunctions.extractEmbeddedImageBytesFromSvg(svgContent);

    return _ResolvedNetworkSvg(
      svgContent: svgContent,
      embeddedImageBytes: embeddedImageBytes,
    );
  }
}

class _ResolvedNetworkSvg {
  const _ResolvedNetworkSvg({
    required this.svgContent,
    required this.embeddedImageBytes,
  });

  final String svgContent;
  final Uint8List? embeddedImageBytes;
}

class _DefaultPicturePlaceholder extends StatelessWidget {
  const _DefaultPicturePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.grayHintTextColor,
        ),
      ),
    );
  }
}

class _DefaultPictureError extends StatelessWidget {
  const _DefaultPictureError();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(
        Icons.broken_image_outlined,
        color: AppColors.grayHintTextColor,
      ),
    );
  }
}
