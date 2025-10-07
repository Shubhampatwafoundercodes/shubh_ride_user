//
// import 'package:flutter/material.dart';
//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:rider_pay/view/onboarding/controller/state/onboard_state.dart';
// import 'package:rider_pay/view/onboarding/model/onboard_model.dart';
//
// import '../../../generated/assets.dart' show Assets;
//
// class OnboardingController extends StateNotifier<OnboardingState>{
//   OnboardingController():super (const OnboardingState());
//
//   final PageController pageController = PageController();
//   final List<OnboardingInfo> onboardingPages = const [
//     OnboardingInfo(
//       imageAsset: Assets.imagesOnboarding1,
//       title: 'Book a Ride in Seconds',
//       description: 'Choose your pickup & drop location and get instant cab bookings.',
//     ),
//     OnboardingInfo(
//       imageAsset:Assets.imagesOnboarding2,
//       title: 'Safe & Reliable Drivers',
//       description: 'Verified drivers and safety features ensure a worry-free journey.',
//     ),
//     OnboardingInfo(
//       imageAsset: Assets.imagesOnboarding3,
//       title: 'Multiple Payment Options',
//       description: 'Cashless rides made easy with your preferred payment mode.',
//     ),
//   ];
//
//
//   void updatePage(int index) {
//     state = state.copyWith(currentPage: index);
//   }
//   void nextPage(VoidCallback onFinish) {
//     if (state.currentPage < onboardingPages.length - 1) {
//       pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       onFinish();
//     }
//   }
//   void skip(VoidCallback onSkip) {
//     onSkip();
//   }
//   double get progress => (state.currentPage + 1) / onboardingPages.length;
//
// }
//
// final onboardingProvider =StateNotifierProvider<OnboardingController,OnboardingState>(
//     (ref)=>OnboardingController(),
// );