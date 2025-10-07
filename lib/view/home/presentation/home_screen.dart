import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rider_pay/generated/assets.dart';
import 'package:rider_pay/l10n/app_localizations.dart';
import 'package:rider_pay/main.dart';
import 'package:rider_pay/res/app_border.dart';
import 'package:rider_pay/res/app_color.dart';
import 'package:rider_pay/res/app_constant.dart';
import 'package:rider_pay/res/app_padding.dart';
import 'package:rider_pay/res/app_size.dart';
import 'package:rider_pay/res/constant/common_bottom_sheet.dart';
import 'package:rider_pay/res/constant/const_text.dart';
import 'package:rider_pay/res/constant/custom_image_slider.dart';
import 'package:rider_pay/utils/routes/routes_name.dart';
import 'package:rider_pay/view/home/presentation/widget/address_list_widget.dart';
import 'package:rider_pay/view/home/presentation/widget/vehicle_type_widget.dart';
import 'package:rider_pay/view/home/provider/provider.dart';
import 'package:rider_pay/view/map/presentation/controller/map_controller.dart';
import 'package:rider_pay/view/map/presentation/search_location_screen.dart';
import 'package:rider_pay/view/map/provider/map_provider.dart';
import 'package:rider_pay/view/share_pref/recent_place_provider.dart';
import 'package:rider_pay/view/soket.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // final List<Map<String, dynamic>> exploreItems = [
  //   {"icon": Assets.iconAutoIc, "label": "Shared Auto"},
  //   {"icon": Assets.iconBikeIc, "label": "Bike"},
  //   {"icon": Assets.iconCarIc, "label": "Auto"},
  //   {"icon": Assets.iconAutoIc, "label": "Cab Economy"},
  //   {"icon": Assets.iconCarIc, "label": "Cab Premium"},
  //   {"icon": Assets.iconBikeIc, "label": "Bus"},
  // ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      // SocketService().connect();
      ref.read(addressTypeNotifierProvider.notifier).loadAddressTypes();
      ref.read(profileProvider.notifier).getProfile();
      ref.read(vehicleTypeProvider.notifier).fetchVehicleTypes();
      ref.read(walletProvider.notifier).getWalletHistory();
      ref.read(recentPlacesProvider.notifier).load();


    });
  }
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final mapConState= ref.watch(mapControllerProvider);

    // ref.listen<MapState>(mapControllerProvider, (prev, next) {
    //   if (next.shouldNavigate) {
    //     ref.read(mapControllerProvider.notifier).resetNavigationFlag();
    //     Navigator.pushNamed(context, RouteName.mapScreen);
    //   }
    // });


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
                              // Navigator.pushNamed(context, RouteName.s)
                            },
                            child: VehicleTypeWidget()),

                        AppSizes.spaceH(15),


                        GestureDetector(
                          onTap: (){
                            print("sdffffffffff");
                            // SocketService().joinUser("12", "2830.3993", "525356253");
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
                              return SizedBox(
                                height: screenHeight * 0.2,
                                child: const Center(child: CircularProgressIndicator()),
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
                                  text: "#goShubhRide",
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
        if(mapConState.isMapProcessing) FullScreenLoader()
      ],
    );

  }

  /// BottomSheet for Explore (View All)
  // void _showExploreBottomSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     // isDismissible: false,
  //     // enableDrag: false,
  //     builder: (context) {
  //       return CommonBottomSheet(
  //         title: "All Services",
  //         // isDismissible: false,
  //         // showCloseButton: true,
  //         content: SingleChildScrollView(
  //           child: Center(
  //             child: Wrap(
  //               spacing: 10.w,
  //               runSpacing: 20.h,
  //               alignment: WrapAlignment.center,
  //               children: List.generate(
  //                 exploreItems.length,
  //                     (index) => ExploreItemWidget(
  //                   item: exploreItems[index],
  //                   itemWidth: screenWidth * 0.2,
  //                   itemHeight: screenHeight * 0.09,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //
  // }
}





class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26, // dimmed background
      child: const Center(
        child: CircularProgressIndicator(color: AppColor.primary),
      ),
    );
  }
}




