import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gurukul_bhutpurva/app/app_routes.dart';
import 'package:gurukul_bhutpurva/core/constants/app_colors.dart';
import 'package:gurukul_bhutpurva/data/models/batch/batch_model.dart';
import 'package:gurukul_bhutpurva/data/models/program/program_model.dart';
import 'package:gurukul_bhutpurva/modules/assigned/controllers/programs_controller.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class Programs extends GetView<ProgramsController> {
  const Programs({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              controller.currentIndex.value == 0 ? 'Programs' : 'Members',
              key: ValueKey(controller.currentIndex.value),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value &&
              controller.programs.isEmpty &&
              controller.members.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.getPrograms();
              await controller.getBatchMembers();
            },
            child: controller.currentIndex.value == 0
                ? const ProgramsList()
                : const MembersList(),
          );
        }),
        floatingActionButton: controller.currentIndex.value == 0
            ? FloatingActionButton.extended(
                heroTag: 'addProgram',
                onPressed: () => _openAddProgramDialog(context),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                label: const Text(
                  'Add Program',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                icon: const Icon(Icons.add_rounded),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsRegular.calendarDots),
              activeIcon: Icon(PhosphorIconsFill.calendarDots),
              label: 'Programs',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIconsRegular.users),
              activeIcon: Icon(PhosphorIconsFill.users),
              label: 'Members',
            ),
          ],
        ),
      ),
    );
  }

  void _openAddProgramDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// DRAG HANDLE
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// TITLE
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      PhosphorIconsFill.calendarPlus,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'New Program',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              /// NAME
              TextFormField(
                controller: nameCtrl,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Program Name',
                  hintText: 'e.g. Weekly Satsang',
                  prefixIcon: const Icon(PhosphorIconsRegular.textAa),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// DESCRIPTION
              TextFormField(
                controller: descCtrl,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Brief description of the program',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 48),
                    child: Icon(PhosphorIconsRegular.notepad),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// DATE
              StatefulBuilder(
                builder: (context, setState) {
                  return TextFormField(
                    controller: dateCtrl,
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        selectedDate = picked;
                        dateCtrl.text = DateFormat(
                          'dd MMM yyyy',
                        ).format(picked);
                        setState(() {});
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'Select program date',
                      prefixIcon: const Icon(
                        PhosphorIconsRegular.calendarBlank,
                      ),
                      suffixIcon: const Icon(
                        PhosphorIconsRegular.caretDown,
                        size: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              /// ACTION BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameCtrl.text.trim();
                        final desc = descCtrl.text.trim();

                        if (name.isEmpty ||
                            desc.isEmpty ||
                            selectedDate == null) {
                          Get.snackbar(
                            "Error",
                            "All fields are required",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        Navigator.pop(ctx);
                        controller.addProgram(
                          name: name,
                          description: desc,
                          date: selectedDate!,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create Program',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────
// Programs Tab
// ─────────────────────────────────────
class ProgramsList extends StatelessWidget {
  const ProgramsList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProgramsController.instance;

    return Obx(() {
      if (controller.programs.isEmpty && !controller.isLoading.value) {
        return _EmptyState(
          icon: PhosphorIconsRegular.calendarX,
          title: 'No Programs Yet',
          subtitle: 'Tap the button below to create your first program.',
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: controller.programs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final program = controller.programs[index];
          return _ProgramCard(program: program);
        },
      );
    });
  }
}

class _ProgramCard extends StatelessWidget {
  final ProgramModel program;

  const _ProgramCard({required this.program});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDate = program.date != null;
    final dateFormatted = hasDate
        ? DateFormat('dd MMM yyyy').format(program.date!)
        : null;
    final batchName = program.batchId?.name;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.toNamed(AppRoutes.programDetails, arguments: program);
        },
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              /// CALENDAR ICON BOX
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: hasDate
                      ? [
                          Text(
                            DateFormat('dd').format(program.date!),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              height: 1.1,
                            ),
                          ),
                          Text(
                            DateFormat('MMM').format(program.date!),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary.withValues(alpha: 0.7),
                            ),
                          ),
                        ]
                      : [
                          Icon(
                            PhosphorIconsFill.calendarDots,
                            color: AppColors.primary.withValues(alpha: 0.6),
                            size: 24,
                          ),
                        ],
                ),
              ),
              const SizedBox(width: 14),

              /// TEXT CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// NAME
                    Text(
                      program.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    if (program.description != null &&
                        program.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        program.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),

                    /// META ROW (date + batch)
                    Row(
                      children: [
                        if (dateFormatted != null) ...[
                          _MetaChip(
                            icon: PhosphorIconsRegular.clock,
                            label: dateFormatted,
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (batchName != null)
                          _MetaChip(
                            icon: PhosphorIconsRegular.usersThree,
                            label: batchName,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              /// ARROW
              Icon(
                PhosphorIconsRegular.caretRight,
                size: 18,
                color: AppColors.darkGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.darkGrey),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────
// Members Tab
// ─────────────────────────────────────
class MembersList extends GetView<ProgramsController> {
  const MembersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.members.isEmpty && !controller.isLoading.value) {
        return _EmptyState(
          icon: PhosphorIconsRegular.usersThree,
          title: 'No Members Found',
          subtitle: 'Members will appear here once the batch is populated.',
        );
      }

      return Column(
        children: [
          _searchBar(),
          Expanded(child: _memberList()),
        ],
      );
    });
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              PhosphorIconsRegular.magnifyingGlass,
              color: AppColors.darkGrey,
            ),
            hintText: 'Search members...',
            hintStyle: TextStyle(color: AppColors.grey, fontSize: 14),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          onChanged: (_) => controller.checkSearch(),
        ),
      ),
    );
  }

  Widget _memberList() {
    return Obx(() {
      final grouped = controller.isSearch.value
          ? controller.groupedFMembers
          : controller.groupedMembers;

      if (grouped.isEmpty) {
        return Center(
          child: Text(
            'No matching members',
            style: TextStyle(color: AppColors.darkGrey),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final entry = grouped.entries.elementAt(index);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _alphabetHeader(entry.key),
              ...entry.value.map((m) => _memberTile(m)),
              const SizedBox(height: 8),
            ],
          );
        },
      );
    });
  }

  Widget _alphabetHeader(String letter) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          letter,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _memberTile(BatchStudentModel member) {
    final initials = member.fullName.isNotEmpty
        ? member.fullName[0].toUpperCase()
        : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            initials,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              fontSize: 16,
            ),
          ),
        ),
        title: Text(
          member.fullName,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        trailing: Icon(
          PhosphorIconsRegular.caretRight,
          size: 16,
          color: AppColors.darkGrey,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────
// Shared empty state
// ─────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
