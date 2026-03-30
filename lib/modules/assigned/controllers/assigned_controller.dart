import 'package:get/get.dart';

class AssignedController extends GetxController {
  /// Assigned classes list
  final assignedClasses = <AssignedClass>[].obs;

  /// Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAssignedClasses();
  }

  /// Simulate API call (replace later)
  void fetchAssignedClasses() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 1));

      assignedClasses.assignAll([
        AssignedClass(
          id: "batch_id_101",
          className: "Class 10 - Science",
          batch: "Batch A",
          students: 32,
          status: ClassStatus.active,
        ),
        AssignedClass(
          id: "batch_id_102",
          className: "Class 9 - Maths",
          batch: "Batch B",
          students: 28,
          status: ClassStatus.completed,
        ),
        AssignedClass(
          id: "batch_id_103",
          className: "Class 8 - English",
          batch: "Batch C",
          students: 30,
          status: ClassStatus.active,
        ),
      ]);
    } finally {
      isLoading.value = false;
    }
  }
}

enum ClassStatus { active, completed }

class AssignedClass {
  final String id;
  final String className;
  final String batch;
  final int students;
  final ClassStatus status;

  AssignedClass({
    required this.id,
    required this.className,
    required this.batch,
    required this.students,
    required this.status,
  });
}
