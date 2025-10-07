import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomImageSlider extends StatefulWidget {
  final List<String> imageList;
  final double height;
  final Function(int)? onPageChanged;
  final BoxFit fit;
  final double viewportFraction;

  const CustomImageSlider({
    super.key,
    required this.imageList,
    this.height = 250,
    this.fit = BoxFit.fill,
    this.viewportFraction = 1,
    this.onPageChanged,
  });

  @override
  State<CustomImageSlider> createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final validImages = widget.imageList.where((path) {
      return path.isNotEmpty;
    }).toList();

    return validImages.isEmpty
        ? const SizedBox.shrink()
        : Column(
      children: [
        CarouselSlider.builder(
          itemCount: validImages.length,
          itemBuilder: (context, index, realIndex) {
            final rawPath = validImages[index];
            final isNetwork = rawPath.startsWith("http");

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: isNetwork
                    ? Image.network(
                  rawPath,
                  fit: widget.fit,
                  width: double.infinity,
                  loadingBuilder:
                      (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                        child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image,
                        size: 50, color: Colors.grey);
                  },
                )
                    : Image.asset(
                  rawPath,
                  fit: widget.fit,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image,
                        size: 50, color: Colors.grey);
                  },
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: widget.height,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: widget.viewportFraction,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayCurve: Curves.fastOutSlowIn,
            // onPageChanged: (index, reason) {
            //   setState(() => _current = index);
            //   widget.onPageChanged?.call(index);
            // },
          ),
        ),
        // const SizedBox(height: 8),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: List.generate(
        //     validImages.length,
        //         (index) => Container(
        //       width: _current == index ? 20 : 12,
        //       height: 8,
        //       margin: const EdgeInsets.symmetric(horizontal: 3),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(8),
        //         color: _current == index
        //             ? Colors.amber
        //             : Colors.grey.shade400,
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
