import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/data/models/member/member_model.dart';
import 'package:gurukul_bhutpurva/data/models/program/program_model.dart';
import 'package:gurukul_bhutpurva/modules/assigned/controllers/programs_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Programs extends GetView<ProgramsController> {
  const Programs({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: (controller.currentIndex.value == 0)
              ? const Text('Programs')
              : const Text('Members'),
        ),
        body: Obx(
          () => (controller.currentIndex.value == 0)
              ? ProgramsList()
              : MembersList(),
        ),
        floatingActionButton: (controller.currentIndex.value == 0)
            ? FloatingActionButton.extended(
                onPressed: () {
                  openAddProgramDialog(context, controller.addProgram);
                },
                label: const Text('Add Program'),
                icon: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Programs'),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsFill.user),
              label: 'Members',
            ),
          ],
        ),
      ),
    );
  }

  openAddProgramDialog(BuildContext context, Function(String) onSubmit) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Add Program',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// PROGRAM NAME FIELD
              TextFormField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Program Name',
                  hintText: 'Enter program name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            /// CANCEL
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),

            /// SAVE
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isEmpty) return;

                Navigator.pop(context);
                onSubmit(value);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class ProgramsList extends StatelessWidget {
  const ProgramsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProgramsController.instance;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// PROGRAM LIST
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.programs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final program = controller.programs[index];
              return _programCard(program);
            },
          ),
        ],
      ),
    );
  }

  /// PROGRAM CARD
  Widget _programCard(ProgramModel program) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.programDetails, arguments: program);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// PROGRAM NAME
                Text(
                  program.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (program.details != null && program.details!.isNotEmpty) ...[
                  const SizedBox(height: 6),

                  /// PROGRAM DETAILS
                  Text(
                    program.details!,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class MembersList extends GetView<ProgramsController> {
  const MembersList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [_searchBar(), _memberList()]),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(Get.context!).copyWith(
            inputDecorationTheme: const InputDecorationTheme(
              border: InputBorder.none,
            ),
          ),
          child: TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              icon: const Icon(Icons.search),
              hintText: 'Search',
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            onChanged: (value) {
              controller.checkSearch();
            },
          ),
        ),
      ),
    );
  }

  Widget _memberList() {
    return Obx(() {
      final grouped = controller.isSearch.value
          ? controller.groupedFMembers
          : controller.groupedMembers;

      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_alphabetHeader(entry.key), _memberCard(entry.value)],
          );
        }).toList(),
      );
    });
  }

  Widget _alphabetHeader(String letter) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          letter,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _memberCard(List<MemberModel> members) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: members.map((member) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(member.name),
          );
        }).toList(),
      ),
    );
  }
}
