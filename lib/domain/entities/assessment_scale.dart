class AssessmentScale {
  const AssessmentScale({
    required this.id,
    required this.title,
    required this.description,
    required this.dimensions,
  });

  final String id;
  final String title;
  final String description;
  final List<ScaleDimension> dimensions;
}

class ScaleDimension {
  const ScaleDimension({
    required this.id,
    required this.name,
    required this.questions,
  });

  final String id;
  final String name;
  final List<ScaleQuestion> questions;
}

class ScaleQuestion {
  const ScaleQuestion({
    required this.id,
    required this.prompt,
    required this.minLabel,
    required this.maxLabel,
  });

  final String id;
  final String prompt;
  final String minLabel;
  final String maxLabel;
}
