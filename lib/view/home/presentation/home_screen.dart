import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay_user/generated/assets.dart';
import 'package:rider_pay_user/l10n/app_localizations.dart';
import 'package:rider_pay_user/main.dart';
import 'package:rider_pay_user/res/app_border.dart';
import 'package:rider_pay_user/res/app_color.dart';
import 'package:rider_pay_user/res/app_constant.dart';
import 'package:rider_pay_user/res/app_padding.dart';
import 'package:rider_pay_user/res/app_size.dart';
import 'package:rider_pay_user/res/constant/const_text.dart';
import 'package:rider_pay_user/res/constant/custom_image_slider.dart';
import 'package:rider_pay_user/utils/routes/routes_name.dart';
import 'package:rider_pay_user/view/home/presentation/widget/address_list_widget.dart';
import 'package:rider_pay_user/view/home/presentation/widget/vehicle_type_widget.dart';
import 'package:rider_pay_user/view/home/provider/provider.dart';
import 'package:rider_pay_user/view/map/presentation/controller/check_zone_notifer.dart';
import 'package:rider_pay_user/view/map/presentation/controller/state/map_state.dart';
import 'package:rider_pay_user/view/map/provider/map_provider.dart';
import 'package:rider_pay_user/view/share_pref/recent_place_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      ref.read(addressTypeNotifierProvider.notifier).loadAddressTypes();
      ref.read(mapControllerProvider.notifier).fetchCurrentLocation(type: LocationType.pickup);
      ref.read(profileProvider.notifier).getProfile();
      ref.read(vehicleTypeProvider.notifier).fetchVehicleTypes();
      ref.read(walletProvider.notifier).getWalletHistory();
      ref.read(recentPlacesProvider.notifier).load();
      final bookingNotifier = ref.read(rideBookingProvider.notifier);
      final hasPending = await bookingNotifier.setupPendingRideAndDrawRoute();
      if (hasPending && mounted) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(context, RouteName.mapScreen,(routes)=>false);
          }
        });
      } else {
        debugPrint("🏠 No active ride found — staying on Home");
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final mapConState= ref.watch(mapControllerProvider);
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        Scaffold(
          body:     SafeArea(
            child: Column(
              children: [
                /// Top Search Bar
                Container(
                  padding: AppPadding.screenPadding,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Scaffold.of(context).openDrawer();
                          Navigator.pushNamed(context, RouteName.drawer);
                        },
                        child: const Icon(Icons.menu_outlined),
                      ),
                      AppSizes.spaceW(12),
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, RouteName.searchLocationScreen);

                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: AppBorders.largeRadius,
                              color: context.greyLight,
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search,),
                                AppSizes.spaceW(8),
                                ConstText(
                                  text: loc.whereAreYouGoing,
                                  fontWeight: AppConstant.semiBold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColor.grey, thickness: 0.8, height: 0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        AddressListWidget(isFromSearch: false,),
                        AppSizes.spaceH(15),
                       /// vehicle type Widget
                        GestureDetector(
                            onTap: (){
                            },
                            child: VehicleTypeWidget()),

                        AppSizes.spaceH(15),


                        GestureDetector(
                          onTap: (){

                          },
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: AppPadding.screenPaddingH,
                              child: ConstText(
                                text: loc.goPlacesWithRiderPay,
                                fontWeight: AppConstant.semiBold,
                                color: context.greyDark,
                                fontSize: AppConstant.fontSizeThree,
                                // color: AppColor.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        AppSizes.spaceH(15),
                        Consumer(
                          builder: (context, ref, _) {
                            final appInfoState = ref.watch(appInfoNotifierProvider);
                            final homeSliders = ref.watch(appInfoNotifierProvider.notifier).homeSliders;
                            if (appInfoState.isLoading) {
                              return SizedBox.shrink(
                                // height: screenHeight * 0.2,
                                // child: const Center(child: CircularProgressIndicator()),
                              );
                            }
                            if (homeSliders.isEmpty) {
                              return SizedBox.shrink();
                            }
                            final imageList = homeSliders.map((e) => e.imageUrl ?? "").toList();

                            return CustomImageSlider(
                              imageList: imageList,
                              height: screenHeight * 0.2,
                              onPageChanged: (index) {
                                debugPrint("Slider page changed: $index");
                              },
                            );
                          },
                        ),
                        AppSizes.spaceH(10),
                        Container(
                          height: screenHeight * 0.45,
                          width: screenWidth,
                          padding: AppPadding.screenPadding,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.imagesHomeBBg),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(top: 55.h),
                                child: ConstText(
                                  text: "#goRiderPay",
                                  fontSize:40.sp,
                                  fontWeight: AppConstant.extraBold,
                                  color: context.greyMedium,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              ConstText(
                                text: "❤️ ${loc.madeForIndia}",
                                color: AppColor.greyDark,
                                fontSize: AppConstant.fontSizeOne,
                              ),
                              ConstText(
                                text: "🚩${loc.craftedInLucknow}",
                                color: AppColor.greyDark,
                                fontSize: AppConstant.fontSizeOne,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if(mapConState.isMapProcessing || mapConState.isLocationLoading || ref.watch(checkZoneProvider).isLoading) FullScreenLoader()
      ],
    );

  }

}





class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26, // dimmed background
      child:  Center(
        child: CircularProgressIndicator(color:context.primary),
      ),
    );
  }
}




