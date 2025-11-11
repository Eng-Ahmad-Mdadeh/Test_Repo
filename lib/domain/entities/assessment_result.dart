class AssessmentResult {
  const AssessmentResult({
    required this.patientId,
    required this.scaleId,
    required this.score,
    required this.level,
    required this.completedOn,
  });

  final String patientId;
  final String scaleId;
  final double score;
  final String level;
  final DateTime completedOn;
}
