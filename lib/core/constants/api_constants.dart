class ApiConstants {
  static const baseUrl = 'http://192.168.29.26:5000';

  // Helper method to build URLs with query parameters
  static String _buildUrl(String path, Map<String, dynamic> params) {
    final List<String> queryParts = [];
    params.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        queryParts.add('$key=${Uri.encodeComponent(value.toString())}');
      }
    });

    if (queryParts.isEmpty) return path;
    return '$path?${queryParts.join('&')}';
  }

  // Auth
  static const google = "/auth/google-login";
  static const register = "/auth/register";
  static const sendOtp = "/auth/send-otp";
  static const verifyOtp = "/auth/verify-otp";
  static const logout = "/auth/logout";

  // location
  static String location({String? typeFilter, String? parentId}) => _buildUrl(
    "/location/dropdown",
    {'typeFilter': typeFilter, 'parentIdFilter': parentId},
  );

  // branch
  static String branches({String? search}) =>
      _buildUrl("/branch/dropdown", {'search': search});

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

  // survey
  static const surveys = "/survey/get";
  static String surveyById(String id) => "/survey/get/$id";
  static String submitSurvey = "/survey/response";

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
  static const appTerms = "$legality?type=activist_policy";

  // tithi calendar
  static String tithiCalendar({int? year}) =>
      _buildUrl('/tithiCalender', {'year': year});

  // groups
  static String groups({
    int page = 1,
    int? limit,
    String? query,
    bool? status,
  }) {
    return _buildUrl('/group/get', {
      'page': page,
      'limit': limit,
      'search': query,
      'isActive': status,
    });
  }

  static String groupDetails(String id) => "/group/get/$id";

  // batch
  // static String batch() => "/batch/get";
  static String batchDetails(String id) => "/batch/get/$id";

  // program
  static String createProgram = "/program/create";
  static String getProgram({
    int page = 1,
    int? limit,
    String? query,
    String? batchFilter,
  }) {
    return _buildUrl('/program/get', {
      'page': page,
      'limit': limit,
      'search': query,
      'batchFilter': batchFilter,
    });
  }

  static String getProgramById(String id) => "/program/$id";
  static String updateProgram = "/program/update";
  static String deleteProgram(String id) => "/program/$id";

  // program attendance
  static String programAttendance(String id) => "/attendance/program/$id";
  static String updateAttendance = "/attendance/update";
}
