import 'package:flutter/material.dart';

import '../state/app_state.dart';
import 'assessment_page.dart';
import 'dashboard_page.dart';
import 'insights_page.dart';
import 'patients_page.dart';

enum HomeTab { dashboard, patients, assessment, insights }

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.state});

  final AppState state;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  HomeTab _current = HomeTab.dashboard;

  void _onTabChange(int index) {
    setState(() => _current = HomeTab.values[index]);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.state.isLoading;
    final body = switch (_current) {
      HomeTab.dashboard => DashboardPage(state: widget.state),
      HomeTab.patients => PatientsPage(state: widget.state),
      HomeTab.assessment => AssessmentPage(state: widget.state),
      HomeTab.insights => InsightsPage(state: widget.state),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return Scaffold(
          body: Row(
            children: [
              if (isWide)
                _NavigationRail(
                  current: _current,
                  onTabChange: _onTabChange,
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                          child: body,
                        ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: isWide
              ? null
              : _BottomNav(current: _current, onTabChange: _onTabChange),
        );
      },
    );
  }
}

class _NavigationRail extends StatelessWidget {
  const _NavigationRail({required this.current, required this.onTabChange});

  final HomeTab current;
  final ValueChanged<int> onTabChange;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      extended: true,
      selectedIndex: current.index,
      onDestinationSelected: onTabChange,
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.6),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.auto_graph_outlined),
          label: Text('لوحة التحكم'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.groups_3_outlined),
          label: Text('المرضى'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.assignment_add_outlined),
          label: Text('التقييم'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.insights_outlined),
          label: Text('الرؤى'),
        ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.current, required this.onTabChange});

  final HomeTab current;
  final ValueChanged<int> onTabChange;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 72,
      selectedIndex: current.index,
      onDestinationSelected: onTabChange,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.auto_graph_outlined),
          label: 'التحكم',
        ),
        NavigationDestination(
          icon: Icon(Icons.groups_3_outlined),
          label: 'المرضى',
        ),
        NavigationDestination(
          icon: Icon(Icons.assignment_add_outlined),
          label: 'التقييم',
        ),
        NavigationDestination(
          icon: Icon(Icons.insights_outlined),
          label: 'الرؤى',
        ),
      ],
    );
  }
}
