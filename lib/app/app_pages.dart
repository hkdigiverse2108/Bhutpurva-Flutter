import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/core/transitions/fade_slide_transition.dart';
import 'package:gurukul_bhutpurva/modules/anubhuti/bindings/anubhuti_binding.dart';
import 'package:gurukul_bhutpurva/modules/anubhuti/views/anubhuti.dart';
import 'package:gurukul_bhutpurva/modules/assigned/binding/assigned_binding.dart';
import 'package:gurukul_bhutpurva/modules/assigned/binding/program_binding.dart';
import 'package:gurukul_bhutpurva/modules/assigned/views/assigned.dart';
import 'package:gurukul_bhutpurva/modules/assigned/views/program_details.dart';
import 'package:gurukul_bhutpurva/modules/assigned/views/programs.dart';
import 'package:gurukul_bhutpurva/modules/attendance/binding/attendance_binding.dart';
import 'package:gurukul_bhutpurva/modules/attendance/views/attendance.dart';
import 'package:gurukul_bhutpurva/modules/auth/bindings/login_binding.dart';
import 'package:gurukul_bhutpurva/modules/auth/bindings/register_binding.dart';
import 'package:gurukul_bhutpurva/modules/auth/bindings/switch_profile_binding.dart';
import 'package:gurukul_bhutpurva/modules/auth/views/account_not_found.dart';
import 'package:gurukul_bhutpurva/modules/auth/views/login.dart';
import 'package:gurukul_bhutpurva/modules/auth/views/otp.dart';
import 'package:gurukul_bhutpurva/modules/auth/views/phone_login.dart';
import 'package:gurukul_bhutpurva/modules/auth/views/register.dart';
import 'package:gurukul_bhutpurva/modules/auth/views/switch_profile.dart';
import 'package:gurukul_bhutpurva/modules/convener/bindings/batch_binding.dart';
import 'package:gurukul_bhutpurva/modules/convener/bindings/convener_binding.dart';
import 'package:gurukul_bhutpurva/modules/convener/views/batch_details.dart';
import 'package:gurukul_bhutpurva/modules/convener/views/convener.dart';
import 'package:gurukul_bhutpurva/modules/convener/views/groups.dart';
import 'package:gurukul_bhutpurva/modules/home/bindings/home_binding.dart';
import 'package:gurukul_bhutpurva/modules/home/views/home.dart';
import 'package:gurukul_bhutpurva/modules/life_light/bindings/life_light_binding.dart';
import 'package:gurukul_bhutpurva/modules/life_light/views/life_light.dart';
import 'package:gurukul_bhutpurva/modules/life_light/views/status.dart';
import 'package:gurukul_bhutpurva/modules/manage/emails/binding/emails_binding.dart';
import 'package:gurukul_bhutpurva/modules/manage/emails/views/emails.dart';
import 'package:gurukul_bhutpurva/modules/manage/family/binding/family_binding.dart';
import 'package:gurukul_bhutpurva/modules/manage/family/views/family.dart';
import 'package:gurukul_bhutpurva/modules/member/bindings/member_binding.dart';
import 'package:gurukul_bhutpurva/modules/member/views/member_update.dart';
import 'package:gurukul_bhutpurva/modules/menu/bindings/menu_binding.dart';
import 'package:gurukul_bhutpurva/modules/menu/options/about_app/bindings/about_app_binding.dart';
import 'package:gurukul_bhutpurva/modules/menu/options/about_app/views/about_app.dart';
import 'package:gurukul_bhutpurva/modules/menu/options/policies/bindings/policies_binding.dart';
import 'package:gurukul_bhutpurva/modules/menu/options/policies/views/policies.dart';
import 'package:gurukul_bhutpurva/modules/menu/options/technical_support/bindings/technical_support_binding.dart';
import 'package:gurukul_bhutpurva/modules/menu/options/technical_support/views/technical_support.dart';
import 'package:gurukul_bhutpurva/modules/menu/views/menu.dart';
import 'package:gurukul_bhutpurva/modules/my_details/binding/my_details_binding.dart';
import 'package:gurukul_bhutpurva/modules/my_details/views/my_details.dart';
import 'package:gurukul_bhutpurva/modules/navigation/bindings/navigation_binding.dart';
import 'package:gurukul_bhutpurva/modules/navigation/views/navigation.dart';
import 'package:gurukul_bhutpurva/modules/profile/bindings/profile_binding.dart';
import 'package:gurukul_bhutpurva/modules/profile/bindings/update_profile_binding.dart';
import 'package:gurukul_bhutpurva/modules/profile/views/profile.dart';
import 'package:gurukul_bhutpurva/modules/profile/views/update_profile.dart';
import 'package:gurukul_bhutpurva/modules/sgis/binding/sgis_binding.dart';
import 'package:gurukul_bhutpurva/modules/sgis/views/sgis_page.dart';
import 'package:gurukul_bhutpurva/modules/splash/views/splash.dart';
import 'package:gurukul_bhutpurva/modules/survey/binding/survey_binding.dart';
import 'package:gurukul_bhutpurva/modules/survey/views/survey.dart';
import 'package:gurukul_bhutpurva/modules/tithi_calendar/bindings/tithi_calender_binding.dart';
import 'package:gurukul_bhutpurva/modules/tithi_calendar/views/tithi_calender.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const Splash(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const Login(),
      binding: LoginBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.phoneLogin,
      page: () => const PhoneLogin(),
      binding: LoginBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const Otp(),
      binding: LoginBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.accountNotFound,
      page: () => const AccountNotFound(),
      binding: LoginBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const Register(),
      binding: RegisterBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.switchProfile,
      page: () => SwitchProfile(),
      binding: SwitchProfileBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.navigation,
      page: () => Navigation(),
      binding: NavigationBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => Profile(),
      binding: ProfileBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.menu,
      page: () => Menu(),
      binding: MenuBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.technicalSupport,
      page: () => TechnicalSupport(),
      binding: TechnicalSupportBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.aboutApp,
      page: () => AboutApp(),
      binding: AboutAppBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.policies,
      page: () => Policies(),
      binding: PoliciesBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.emails,
      page: () => Emails(),
      binding: EmailsBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.family,
      page: () => Family(),
      binding: FamilyBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    // home
    GetPage(
      name: AppRoutes.lifeLight,
      page: () => LifeLight(),
      binding: LifeLightBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.status,
      page: () => Status(),
      binding: LifeLightBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.anubhuti,
      page: () => Anubhuti(),
      binding: AnubhutiBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.tithi,
      page: () => TithiCalender(),
      binding: TithiCalenderBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.sgis,
      page: () => SgisPage(),
      binding: SgisBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.myDetails,
      page: () => MyDetails(),
      binding: MyDetailsBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.attendance,
      page: () => Attendance(),
      binding: AttendanceBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.survey,
      page: () => Survey(),
      binding: SurveyBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.convener,
      page: () => Convener(),
      binding: ConvenerBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.groups,
      page: () => Groups(),
      binding: ConvenerBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.batchDetails,
      page: () => const BatchDetails(),
      binding: BatchBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.assigned,
      page: () => Assigned(),
      binding: AssignedBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.assignedDetails,
      page: () => const BatchDetails(),
      binding: BatchBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.programs,
      page: () => Programs(),
      binding: ProgramBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.programDetails,
      page: () => ProgramDetails(),
      binding: ProgramBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.updateProfile,
      page: () => UpdateProfile(),
      binding: UpdateProfileBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
    GetPage(
      name: AppRoutes.memberUpdate,
      page: () => MemberUpdate(),
      binding: MemberBinding(),
      customTransition: FadeSlideTransition(),
      transitionDuration: const Duration(milliseconds: 900),
    ),
  ];
}
