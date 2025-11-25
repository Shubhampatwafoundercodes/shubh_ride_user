import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_user/generated/assets.dart';
import 'package:rider_pay_user/view/home/data/model/app_info_model.dart';
import 'package:rider_pay_user/view/home/domain/repo/app_Info_repo.dart';
import 'package:rider_pay_user/view/onboarding/model/onboard_model.dart';

class AppInfoState {
  final bool isLoading;
  final AppInfoModel? appInfoModel;
  final int currentPage;

  AppInfoState({
    this.isLoading = false,
    this.appInfoModel,
    this.currentPage = 0,
  });

  AppInfoState copyWith({
    bool? isLoading,
    AppInfoModel? appInfoModel,
    int? currentPage,
  }) {
    return AppInfoState(
      isLoading: isLoading ?? this.isLoading,
      appInfoModel: appInfoModel ?? this.appInfoModel,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class AppInfoNotifier extends StateNotifier<AppInfoState> {
  final AppInfoRepo repo;

  AppInfoNotifier(this.repo) : super(AppInfoState());

  final PageController pageController = PageController();

  // 📌 Local fallback list
  final List<OnboardingInfo> fallbackSlides = const [
    OnboardingInfo(
      imageAsset: Assets.imagesOnboarding1,
      title: 'Book a Ride in Seconds',
      description: 'Choose your pickup & drop location and get instant cab bookings.',
    ),
    OnboardingInfo(
      imageAsset: Assets.imagesOnboarding2,
      title: 'Safe & Reliable Drivers',
      description: 'Verified drivers and safety features ensure a worry-free journey.',
    ),
    OnboardingInfo(
      imageAsset: Assets.imagesOnboarding3,
      title: 'Multiple Payment Options',
      description: 'Cashless rides made easy with your preferred payment mode.',
    ),
  ];

  // 📌 API call
  Future<void> loadAppInfo() async {

    state = state.copyWith(isLoading: true,);
    try {
      final res = await repo.fetchAppInfo();
      if (res.code == 200) {
        state = state.copyWith(isLoading: false, appInfoModel: res);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false,);
      debugPrint(e.toString());
    }
  }
  // ✅ Home banners
  List<HomeSlider> get homeSliders =>
      state.appInfoModel?.data?.homeSliders ?? [];

  // ✅ FAQs
  List<Faq> get faqs => state.appInfoModel?.data?.faqs ?? [];
  // ✅ Getter for app name
  // String get appName => state.appInfoModel?.data?.name ?? "";

  // ✅ Getter for app logo
  // String get appLogo => state.appInfoModel?.data?.logo ?? "";

  // ✅ Onboarding slides
  List<dynamic> get onboardingSlides {
    final apiSlides = state.appInfoModel?.data?.splashSliders;
    if (apiSlides != null && apiSlides.isNotEmpty) {
      return apiSlides; // API data
    }
    return fallbackSlides; // fallback list
  }



  // ✅ Onboarding page controls
  void updatePage(int index) {
    state = state.copyWith(currentPage: index);
  }

  void nextPage(VoidCallback onFinish) {
    if (state.currentPage < onboardingSlides.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      onFinish();
    }
  }

  void skip(VoidCallback onSkip) {
    onSkip();
  }

  double get progress =>
      onboardingSlides.isEmpty ? 0 : (state.currentPage + 1) / onboardingSlides.length;
}
