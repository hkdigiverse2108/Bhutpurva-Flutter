class ProgramModel {
  final String id;
  final String name;
  final String? details;

  ProgramModel({required this.id, required this.name, this.details});

  factory ProgramModel.empty() {
    return ProgramModel(id: '', name: '', details: '');
  }
}
