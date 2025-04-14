import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/glucosa_screen.dart';
import 'screens/configuracion_screen.dart';
import 'screens/recommendations_screen.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await NotificationService.initialize();
  AppLocalizations.localization.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Diabetes HabitsApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: AppLocalizations.localization.localizationsDelegates,
      supportedLocales: AppLocalizations.localization.supportedLocales,
      localeResolutionCallback: AppLocalizations.localization.localeResolutionCallback,
      routerConfig: AppLocalizations.localization.routerConfig,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    GlucosaScreen(),
    ConfiguracionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: localizations!.translate('habits'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: localizations.translate('glucosa'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: localizations.translate('configuracion'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddHabitDialog(onHabitAdded: _addHabit),
                );
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 2) {
        Navigator.pushNamed(context, '/recommendations');
      }
    });
  }

  List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final List<Map<String, dynamic>> encodedHabits = StorageService.getHabits();
    setState(() {
      _habits = encodedHabits.map((habit) => Habit.fromJson(habit)).toList();
    });
  }

  Future<void> _saveHabits() async {
    final List<Map<String, dynamic>> encodedHabits =
        _habits.map((habit) => habit.toJson()).toList();
    await StorageService.saveHabits(encodedHabits);
  }

  void _addHabit(Habit habit) {
    setState(() {
      _habits.add(habit);
    });
    _saveHabits();
    if (habit.reminderTime != null) {
      _scheduleHabitNotification(habit);
    }
  }

  void _toggleHabit(Habit habit) {
    setState(() {
      habit.isCompleted = !habit.isCompleted;
    });
    _saveHabits();
    if (habit.reminderTime != null) {
      _scheduleHabitNotification(habit);
    }
  }

  void _editHabit(Habit oldHabit, Habit newHabit) {
    setState(() {
      final index = _habits.indexOf(oldHabit);
      if (index != -1) {
        _habits[index] = newHabit;
      }
    });
    _saveHabits();
    if (newHabit.reminderTime != oldHabit.reminderTime) {
      NotificationService.cancelNotification(_habits.indexOf(oldHabit));
      if (newHabit.reminderTime != null) {
        _scheduleHabitNotification(newHabit);
      }
    }
  }

  void _deleteHabit(Habit habit) {
    setState(() {
      _habits.remove(habit);
    });
    _saveHabits();
    NotificationService.cancelNotification(_habits.indexOf(habit));
  }

  Future<void> _scheduleHabitNotifications() async {
    for (var habit in _habits) {
      if (habit.reminderTime != null) {
        final now = DateTime.now();
        final scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          habit.reminderTime!.hour,
          habit.reminderTime!.minute,
        );
        if (scheduledTime.isAfter(now)) {
          NotificationService.scheduleNotification(
            id: _habits.indexOf(habit),
            title: 'Recordatorio de Hábito',
            body: '¡No olvides: ${habit.title}!',
            scheduledDate: scheduledTime,
          );
        }
      }
    }
  }

  Future<void> _scheduleHabitNotification(Habit habit) async {
    if (habit.reminderTime != null) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        habit.reminderTime!.hour,
        habit.reminderTime!.minute,
      );
      if (scheduledTime.isAfter(now)) {
        await NotificationService.scheduleNotification(
          id: _habits.indexOf(habit),
          title: 'Recordatorio de Hábito',
          body: '¡No olvides: ${habit.title}!',
          scheduledDate: scheduledTime,
        );
      }
    }
  }
}

extension HabitPersistence on Habit {
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'reminderTime': reminderTime?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  static Habit fromJson(Map<String, dynamic> json) {
    return Habit(
      title: json['title'],
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'])
          : null,
      isCompleted: json['isCompleted'],
    );
  }
}
