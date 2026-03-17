import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gurukul_bhutpurva/core/constants/api_constants.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/data/models/banner/banner_model.dart';
import 'package:gurukul_bhutpurva/shared/widgets/shimmer/custom_shimmer.dart';

class BannerSlider extends StatefulWidget {
  final List<BannerModel> banners;
  final bool isLoading;

  const BannerSlider({
    super.key,
    required this.banners,
    required this.isLoading,
  });

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  late final PageController _pageController;
  Timer? _timer;

  static const int _initialPage = 1000; // large number for illusion
  int _currentPage = _initialPage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.98,
    );
    _startAutoSlide();
  }

  @override
  void didUpdateWidget(covariant BannerSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.banners.length != oldWidget.banners.length) {
      _startAutoSlide();
    }
  }

  void _startAutoSlide() {
    _timer?.cancel();
    if (widget.banners.length <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;

      _currentPage++;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );

      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  int get _currentIndex => _currentPage % widget.banners.length;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return CustomShimmer(
        isLoading: widget.isLoading,
        child: Container(
          height: 220,
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        ),
      );
    }
    if (widget.banners.isEmpty) return const SizedBox();
    return Container(
      height: 220,
      margin: const EdgeInsets.only(bottom: 10),

      child: Stack(
        children: [
          /// Infinite PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() => _currentPage = page);
            },
            itemBuilder: (_, index) {
              final bannerIndex = index % widget.banners.length;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                // 👈 separator gap
                child: _BannerItem(image: widget.banners[bannerIndex].image),
              );
            },
          ),

          /// Indicator
          if (widget.banners.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.banners.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    width: _currentIndex == i ? 20 : 6,
                    decoration: BoxDecoration(
                      color: _currentIndex == i
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BannerItem extends StatelessWidget {
  final String image;

  const _BannerItem({required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// Image
          Image.network(
            image.startsWith('http') ? image : '${ApiConstants.baseUrl}$image',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey),
                ),
              );
            },
          ),

          /// Spiritual overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          /// Edge separator (very subtle)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
          ),

          /// Text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Seva • Sanskar • Sadhana",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Committed to serve with values",
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
