import 'package:flutter/material.dart';

import '../../domain/entities/patient.dart';

class PatientTile extends StatelessWidget {
  const PatientTile({super.key, required this.patient, this.onTap});

  final Patient patient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final initial = patient.name.isNotEmpty ? patient.name.substring(0, 1) : '?';

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    child: Text(
                      initial,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(patient.name, style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text('${patient.age} سنة • ${patient.focusArea}', style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text(patient.status),
                    avatar: const Icon(Icons.schedule, size: 16, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: patient.profileCompletion,
                  minHeight: 8,
                  backgroundColor: Colors.white12,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 8),
              Text('اكتمال الملف ${(patient.profileCompletion * 100).round()}%',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
