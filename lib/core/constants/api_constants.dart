class ApiConstants {
  static const baseUrl = 'http://192.168.29.26:5000';

  // Auth
  static const register = "/auth/register";
  static const sendOtp = "/auth/send-otp";
  static const verifyOtp = "/auth/verify-otp";
  static const logout = "/auth/logout";

  // image
  static const image = "/upload"; // get, post, delete

  // user
  static const getUser = "/user/get";
  static const getUserById = "/user/get/";
  static const updateUser = "/user/update";
  static const updateProfileImage = "/user/update-image";

  // banners
  static const banners = "/banner/get";

  // life light
  static const lifeLight = "/lifeLight/add";
  static String getLifeLightById(String id) => "/lifeLight/user/$id";

  // attendance
  static const attendance = "/attendance/add";
  static String getAttendanceById(String id) => "/attendance/user/$id";

  // feedback
  static const feedback = "/feedback/add";

  // settings
  static const settings = "/setting/get";

  // legality
  static const legality = "/legality/get";
  static const appInfo = "$legality?type=about_app";
  static const appPolicy = "$legality?type=privacy_policy";
  static const appTerms = "$legality?type=terms_and_conditions";
}
