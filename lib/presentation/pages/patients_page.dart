import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../state/app_state.dart';
import '../widgets/patient_tile.dart';

class PatientsPage extends StatelessWidget {
  const PatientsPage({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM', 'ar');

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth < 720
            ? 1
            : constraints.maxWidth < 1080
                ? 2
                : 3;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('سجل المرضى', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 8),
            Text('إدارة العلاقات العلاجية وجدولة المتابعات.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: crossAxisCount == 1 ? 1.8 : 1.4,
                ),
                itemCount: state.patients.length,
                itemBuilder: (context, index) {
                  final patient = state.patients[index];
                  return PatientTile(
                    patient: patient,
                    onTap: () {
                      final snackBar = SnackBar(
                        content: Text(
                          'آخر جلسة: ${dateFormat.format(patient.lastSession)}',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      state.refreshTrendFor(patient.id);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
