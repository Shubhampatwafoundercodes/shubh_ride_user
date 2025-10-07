import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/main.dart';
import 'package:rider_pay/res/app_color.dart' show AppColor, AppColorsExt;
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/common_network_img.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/res/constant/const_text_btn.dart';
import 'package:rider_pay/view/home/data/model/app_info_model.dart';
import 'package:rider_pay/view/home/provider/provider.dart';
import 'package:rider_pay/view/map/provider/map_provider.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/onboarding/model/onboard_model.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(appInfoNotifierProvider.notifier);
    final state = ref.watch(appInfoNotifierProvider);
    final slides = controller.onboardingSlides;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: context.background,
        body:state.isLoading?
          Center(child: CircularProgressIndicator(color: context.primary,))
          : ListView(
          // padding: AppPadding.screenPadding,
          children: [
            AppSizes.spaceH(12),
            Padding(
              padding: AppPadding.screenPaddingH,
              child: Align(
                alignment: Alignment.topLeft,
                child:Image.asset(
                  AppConstant.appLogoLightMode,
                  height: 80.h,
                  // width:screenWidth * 0.3,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              width: screenWidth,
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: slides.length,
                onPageChanged: (index) => controller.updatePage(index),
                itemBuilder: (context, index) {
                  final item = slides[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (item is SplashSlider)
                        CommonNetworkImage(
                          imageUrl: item.imageUrl ?? "",
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width ,
                          fit: BoxFit.contain,

                        )
                      else if (item is OnboardingInfo)
                        Image.asset(
                          item.imageAsset,
                          height:
                          MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width * 0.7,
                          fit: BoxFit.contain,
                        ),
                      AppSizes.spaceH(12),
                      ConstText(
                        text: item is SplashSlider
                            ? (item.title ?? "")
                            : (item as OnboardingInfo).title,
                        fontWeight: AppConstant.medium,
                        color: AppColor.primary,
                        textAlign: TextAlign.center,
                        fontSize: AppConstant.fontSizeThree,
                      ),
                      AppSizes.spaceH(18),
                      ConstText(
                        text: item is SplashSlider
                            ? (item.subTitle ?? "")
                            : (item as OnboardingInfo).description,
                        color: context.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slides.length, (index) {
                bool isActive = state.currentPage == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 10,
                  width: isActive ? 24 : 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: isActive ? context.primary : context.disabled,
                  ),
                );
              }),
            ),
            AppSizes.spaceH(30),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 70.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: context.greyLight, width: 2),
                  ),
                  child: CircularProgressIndicator(
                    value: controller.progress,
                    strokeWidth: 4,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(context.primary),
                  ),
                ),
                GestureDetector(
                  onTap: ()  {
                    controller.nextPage(()async{

                      final hasPermission = await ref.read(locationServiceProvider.notifier).ensurePermission();

                      if (!hasPermission) {
                        Navigator.pushNamed(context, RouteName.locationScreen);
                        return;
                      }

                      Navigator.pushNamed(context, RouteName.welcomeScreen);

                    });

                  },
                  child: CircleAvatar(
                    backgroundColor: context.primary,
                    radius: 28.r,
                    child: Icon(Icons.arrow_forward, color: context.textPrimary),
                  ),
                ),
              ],
            ),
            AppSizes.spaceH(15),
            ConstTextBtn(
              onTap: ()  {

                controller.nextPage(()async{

                  final hasPermission = await ref.read(locationServiceProvider.notifier).ensurePermission();

                  if (!hasPermission) {
                    Navigator.pushNamed(context, RouteName.locationScreen);
                    return;
                  }

                  Navigator.pushNamed(context, RouteName.welcomeScreen);

                });

              },
              text: state.currentPage == slides.length - 1
                  ? "Done"
                  : "Skip",
              textColor: context.primary,
              fontWeight: AppConstant.medium,
            ),
            AppSizes.spaceH(20),
          ],
        ),
      ),
    );
  }
}
