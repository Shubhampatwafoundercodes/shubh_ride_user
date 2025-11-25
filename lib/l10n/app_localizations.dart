import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Rider Pay'**
  String get appTitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @doNotAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get doNotAccount;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Book your ride quickly and easily'**
  String get welcomeSubTitle;

  /// No description provided for @selectYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your language'**
  String get selectYourLanguage;

  /// No description provided for @changeLanguageHelp.
  ///
  /// In en, this message translates to:
  /// **'You can change your language on this screen or at any time in Help.'**
  String get changeLanguageHelp;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @whereAreYouGoing.
  ///
  /// In en, this message translates to:
  /// **'Where are you going?'**
  String get whereAreYouGoing;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @madeForIndia.
  ///
  /// In en, this message translates to:
  /// **'Made for India'**
  String get madeForIndia;

  /// No description provided for @craftedInLucknow.
  ///
  /// In en, this message translates to:
  /// **'Crafted in Lucknow'**
  String get craftedInLucknow;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed!'**
  String get paymentFailed;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @phoneVerification.
  ///
  /// In en, this message translates to:
  /// **'Phone Verification'**
  String get phoneVerification;

  /// No description provided for @enterYourNumber.
  ///
  /// In en, this message translates to:
  /// **'What\'s your number?'**
  String get enterYourNumber;

  /// No description provided for @byContinuing.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the'**
  String get byContinuing;

  /// No description provided for @termsAndPolicy.
  ///
  /// In en, this message translates to:
  /// **' T&C and Privacy Policy'**
  String get termsAndPolicy;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @verifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verifyNow;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account to continue!'**
  String get createAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailOptional;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @goPlacesWithRiderPay.
  ///
  /// In en, this message translates to:
  /// **'Go Places'**
  String get goPlacesWithRiderPay;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dob;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @riderWallet.
  ///
  /// In en, this message translates to:
  /// **'Rider Wallet'**
  String get riderWallet;

  /// No description provided for @lowBalance.
  ///
  /// In en, this message translates to:
  /// **'Low Balance'**
  String get lowBalance;

  /// No description provided for @addMoney.
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get addMoney;

  /// No description provided for @payByUpi.
  ///
  /// In en, this message translates to:
  /// **'Pay by any UPI app'**
  String get payByUpi;

  /// No description provided for @payLater.
  ///
  /// In en, this message translates to:
  /// **'Pay Later'**
  String get payLater;

  /// No description provided for @payAtDrop.
  ///
  /// In en, this message translates to:
  /// **'Pay at drop'**
  String get payAtDrop;

  /// No description provided for @goCashless.
  ///
  /// In en, this message translates to:
  /// **'Go cashless, pay after ride by scanning QR'**
  String get goCashless;

  /// No description provided for @tickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get tickets;

  /// No description provided for @searchHelpTopics.
  ///
  /// In en, this message translates to:
  /// **'Search Help Topics'**
  String get searchHelpTopics;

  /// No description provided for @rideFareIssues.
  ///
  /// In en, this message translates to:
  /// **'Ride fare related Issues'**
  String get rideFareIssues;

  /// No description provided for @captainVehicleIssues.
  ///
  /// In en, this message translates to:
  /// **'Captain and Vehicle related issues'**
  String get captainVehicleIssues;

  /// No description provided for @paymentIssues.
  ///
  /// In en, this message translates to:
  /// **'Pass and Payment related Issues'**
  String get paymentIssues;

  /// No description provided for @parcelIssues.
  ///
  /// In en, this message translates to:
  /// **'Parcel Related Issues'**
  String get parcelIssues;

  /// No description provided for @otherTopics.
  ///
  /// In en, this message translates to:
  /// **'Other Topics'**
  String get otherTopics;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @myRewards.
  ///
  /// In en, this message translates to:
  /// **'My Rewards'**
  String get myRewards;

  /// No description provided for @rewardBalance.
  ///
  /// In en, this message translates to:
  /// **'Reward Balance'**
  String get rewardBalance;

  /// No description provided for @redeemYourRewards.
  ///
  /// In en, this message translates to:
  /// **'Redeem your rewards and enjoy benefits'**
  String get redeemYourRewards;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @referAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get referAndEarn;

  /// No description provided for @inviteFriendsEarn.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends & Earn Rewards'**
  String get inviteFriendsEarn;

  /// No description provided for @referDescription.
  ///
  /// In en, this message translates to:
  /// **'Invite your friends to join and get rewards when they take their first ride.'**
  String get referDescription;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @inviteYourFriend.
  ///
  /// In en, this message translates to:
  /// **'Invite your Friend'**
  String get inviteYourFriend;

  /// No description provided for @sendInviteLink.
  ///
  /// In en, this message translates to:
  /// **'Send them your referral link'**
  String get sendInviteLink;

  /// No description provided for @friendSignsUp.
  ///
  /// In en, this message translates to:
  /// **'Friend Signs Up'**
  String get friendSignsUp;

  /// No description provided for @signupWithReferral.
  ///
  /// In en, this message translates to:
  /// **'They sign up using your referral code'**
  String get signupWithReferral;

  /// No description provided for @earnRewards.
  ///
  /// In en, this message translates to:
  /// **'Earn Rewards'**
  String get earnRewards;

  /// No description provided for @getCashbackOnFirstRide.
  ///
  /// In en, this message translates to:
  /// **'Get cashback when your friend completes their first ride'**
  String get getCashbackOnFirstRide;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @myRating.
  ///
  /// In en, this message translates to:
  /// **'My Rating'**
  String get myRating;

  /// No description provided for @parcelSendItems.
  ///
  /// In en, this message translates to:
  /// **'Parcel - Send Items'**
  String get parcelSendItems;

  /// No description provided for @myRides.
  ///
  /// In en, this message translates to:
  /// **'My Rides'**
  String get myRides;

  /// No description provided for @safety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safety;

  /// No description provided for @referAndEarnSub.
  ///
  /// In en, this message translates to:
  /// **'Get ₹50'**
  String get referAndEarnSub;

  /// No description provided for @powerPass.
  ///
  /// In en, this message translates to:
  /// **'Power Pass'**
  String get powerPass;

  /// No description provided for @rapidoCoins.
  ///
  /// In en, this message translates to:
  /// **'Rapido Coins'**
  String get rapidoCoins;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get enterAmount;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get deleteAccountConfirmMsg;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your account has been deleted successfully.'**
  String get accountDeleted;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMsg;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @safetyConcern.
  ///
  /// In en, this message translates to:
  /// **'Safety Concern'**
  String get safetyConcern;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @cancelRefund.
  ///
  /// In en, this message translates to:
  /// **'Cancel & Refund'**
  String get cancelRefund;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'Driver?'**
  String get driver;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @getEarning.
  ///
  /// In en, this message translates to:
  /// **'Get Earning'**
  String get getEarning;

  /// No description provided for @drop.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get drop;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @dropLocation.
  ///
  /// In en, this message translates to:
  /// **'Drop Location'**
  String get dropLocation;

  /// No description provided for @cashbackMsg.
  ///
  /// In en, this message translates to:
  /// **'You get cashback complete your ride cashback!'**
  String get cashbackMsg;

  /// No description provided for @noVehicle.
  ///
  /// In en, this message translates to:
  /// **'No vehicles available'**
  String get noVehicle;

  /// No description provided for @bookRide.
  ///
  /// In en, this message translates to:
  /// **'Book Ride'**
  String get bookRide;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @searchingDriver.
  ///
  /// In en, this message translates to:
  /// **'Searching for driver...'**
  String get searchingDriver;

  /// No description provided for @driverFound.
  ///
  /// In en, this message translates to:
  /// **'Driver(s) found'**
  String get driverFound;

  /// No description provided for @pleaseConfirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Please confirm payment'**
  String get pleaseConfirmPayment;

  /// No description provided for @rideInProgress.
  ///
  /// In en, this message translates to:
  /// **'Ride in progress'**
  String get rideInProgress;

  /// No description provided for @driverArrivedPickup.
  ///
  /// In en, this message translates to:
  /// **'Driver arrived at pickup'**
  String get driverArrivedPickup;

  /// No description provided for @driverOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Driver on the way'**
  String get driverOnTheWay;

  /// No description provided for @waitingDriverResponse.
  ///
  /// In en, this message translates to:
  /// **'Waiting for driver response'**
  String get waitingDriverResponse;

  /// No description provided for @rideCompleted.
  ///
  /// In en, this message translates to:
  /// **'Ride Completed!'**
  String get rideCompleted;

  /// No description provided for @tripCompletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Your trip has been completed successfully.'**
  String get tripCompletedMsg;

  /// No description provided for @searchNearbyDrivers.
  ///
  /// In en, this message translates to:
  /// **'⏳ Searching for nearby drivers...'**
  String get searchNearbyDrivers;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @paymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get paymentPending;

  /// No description provided for @completePaymentMsg.
  ///
  /// In en, this message translates to:
  /// **'Please complete your payment to continue.'**
  String get completePaymentMsg;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @vehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Number: '**
  String get vehicleNumber;

  /// No description provided for @startRidePin.
  ///
  /// In en, this message translates to:
  /// **'Start your ride using PIN'**
  String get startRidePin;

  /// No description provided for @pickupFrom.
  ///
  /// In en, this message translates to:
  /// **'Pickup From'**
  String get pickupFrom;

  /// No description provided for @dropTo.
  ///
  /// In en, this message translates to:
  /// **'Drop To'**
  String get dropTo;

  /// No description provided for @goToMap.
  ///
  /// In en, this message translates to:
  /// **'Go to Map'**
  String get goToMap;

  /// No description provided for @completeOnlinePayment.
  ///
  /// In en, this message translates to:
  /// **'Complete Online Payment'**
  String get completeOnlinePayment;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @tripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetails;

  /// No description provided for @chatInterfaceWillBeImplementedHere.
  ///
  /// In en, this message translates to:
  /// **'Chat interface will be implemented here'**
  String get chatInterfaceWillBeImplementedHere;

  /// No description provided for @confirmPaymentOf.
  ///
  /// In en, this message translates to:
  /// **'Confirm payment of'**
  String get confirmPaymentOf;

  /// No description provided for @forThisRide.
  ///
  /// In en, this message translates to:
  /// **'for this ride?'**
  String get forThisRide;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
