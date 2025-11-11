import 'package:flutter/material.dart';

import '../../data/repositories/mock_assessment_repository.dart';
import '../../domain/entities/assessment_result.dart';
import '../../domain/entities/assessment_scale.dart';
import '../../domain/entities/patient.dart';
import '../../domain/repositories/assessment_repository.dart';
import '../../domain/usecases/get_assessment_scales.dart';
import '../../domain/usecases/get_dashboard_snapshot.dart';
import '../../domain/usecases/get_insight_cards.dart';
import '../../domain/usecases/get_patients.dart';
import '../../domain/usecases/get_progress_trend.dart';
import '../../domain/usecases/get_recent_results.dart';
import '../../domain/usecases/submit_assessment.dart';

class AppState extends ChangeNotifier {
  AppState({AssessmentRepository? repository})
      : _repository = repository ?? MockAssessmentRepository() {
    _getDashboardSnapshot = GetDashboardSnapshot(_repository);
    _getPatients = GetPatients(_repository);
    _getRecentResults = GetRecentResults(_repository);
    _getAssessmentScales = GetAssessmentScales(_repository);
    _submitAssessment = SubmitAssessment(_repository);
    _getProgressTrend = GetProgressTrend(_repository);
    _getInsightCards = GetInsightCards(_repository);
  }

  final AssessmentRepository _repository;
  AssessmentRepository get repository => _repository;

  late final GetDashboardSnapshot _getDashboardSnapshot;
  late final GetPatients _getPatients;
  late final GetRecentResults _getRecentResults;
  late final GetAssessmentScales _getAssessmentScales;
  late final SubmitAssessment _submitAssessment;
  late final GetProgressTrend _getProgressTrend;
  late final GetInsightCards _getInsightCards;

  bool isLoading = true;
  Map<String, double> dashboardSnapshot = const {};
  List<Patient> patients = const [];
  List<AssessmentResult> recentResults = const [];
  List<AssessmentScale> assessmentScales = const [];
  List<InsightCard> insights = const [];
  List<TrendPoint> currentTrend = const [];

  Future<void> bootstrap() async {
    isLoading = true;
    notifyListeners();

    dashboardSnapshot = await _getDashboardSnapshot();
    patients = await _getPatients();
    recentResults = await _getRecentResults();
    assessmentScales = await _getAssessmentScales();
    insights = await _getInsightCards();
    if (patients.isNotEmpty) {
      currentTrend = await _getProgressTrend(patients.first.id);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshTrendFor(String patientId) async {
    currentTrend = await _getProgressTrend(patientId);
    notifyListeners();
  }

  Future<AssessmentResult> submit({
    required String patientId,
    required String scaleId,
    required Map<String, int> answers,
  }) async {
    final result = await _submitAssessment(
      patientId: patientId,
      scaleId: scaleId,
      answers: answers,
    );
    recentResults = [result, ...recentResults];
    notifyListeners();
    return result;
  }
}
