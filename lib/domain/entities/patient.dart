class Patient {
  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.status,
    required this.focusArea,
    required this.lastSession,
    required this.profileCompletion,
  });

  final String id;
  final String name;
  final int age;
  final String status;
  final String focusArea;
  final DateTime lastSession;
  final double profileCompletion;
}
