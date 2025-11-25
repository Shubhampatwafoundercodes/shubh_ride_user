class ApiUrls {
  static const baseUrl='https://riderpay.codescarts.com/api';
  static const loginUrl='$baseUrl/user/login';
  static const registerUrl='$baseUrl/user/register';
  static const sendOtpUrl = 'https://otp.fctechteam.org/send_otp.php?mode=live&digit=4&mobile=';
  static const verifyOtpUrl = 'https://otp.fctechteam.org/verifyotp.php?mobile=';
  static const getAppInfo ="$baseUrl/system/systemApi";
  static const addressType ="$baseUrl/system/addressType";
  static const getProfile ="$baseUrl/user/getProfile?userId=";
  static const updateProfile ="$baseUrl/user/updateProfile";
  static const deleteProfile ="$baseUrl/user/deleteProfile?userId=";
  static const getVoucherUrl ="$baseUrl/user/getUserVouchers?userId=";
  static const getCmsUrl ="$baseUrl/system/getCmsPages";
  static const vehicleTypeUrl ="$baseUrl/system/vehicleType";
  static const rideBookingUrl ="$baseUrl/booking/createBooking";
  static const cancelBookingUrl ="$baseUrl/booking/cancelBooking";
  static const rideBookingHistoryUrl ="$baseUrl/booking/getBookingHistoryByUserId?userId=";
  static const reasonOfCancel ="$baseUrl/system/reasonOfCancel";
  static const createPaying ="$baseUrl/user/createPayin";
  static const getWalletHistory ="$baseUrl/user/getWalletAndHistory?userId=";
  static const notificationUrl ="$baseUrl/user/getNotifications?userId=";
  static const completePaymentRide ="$baseUrl/booking/updatePaymentDetails";
  static const checkZoneUrl ="$baseUrl/booking/checkZone";

}




class MapUrls{
  static const baseUrl='https://maps.googleapis.com/';
  // static const mapKey="AIzaSyCOqfJTgg1Blp1GIeh7o8W8PC1w5dDyhWI";
  static const mapKey="AIzaSyATBUdpLdjn6rjEHIsnah_ZSVr7p5LnyQ4";
  static const  searchPlaceUrl = 'maps/api/place/autocomplete/json';
  static const  placeDetailsUrl = 'maps/api/place/details/json';
  static const  drawRouteUrl = 'maps/api/directions/json';
  static const  distanceUrl = 'maps/api/distancematrix/json';


}