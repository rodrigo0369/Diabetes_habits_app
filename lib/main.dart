import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/glucosa_screen.dart';
import 'screens/configuracion_screen.dart';
import 'screens/recommendations_screen.dart'; 
import 'services/storage_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await NotificationService.initialize(); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes HabitsApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
      routes: {
        '/recommendations': (context) => RecommendationsScreen(),
      },
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
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Hábitos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bloodtype),
            label: 'Glucosa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
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
        // Si se selecciona Configuración, navega a Recomendaciones
        Navigator.pushNamed(context, '/recommendations');
      }
    });
  }

  void _addHabit(Habit habit) {
    setState(() {
      _habits.add(habit);
    });
    _saveHabits();
  }

  void _toggleHabit(Habit habit) {
    setState(() {
      habit.isCompleted = !habit.isCompleted;
    });
    _saveHabits();
  }

  void _editHabit(Habit oldHabit, Habit newHabit) {
    setState(() {
      final index = _habits.indexOf(oldHabit);
      if (index != -1) {
        _habits[index] = newHabit;
      }
    });
    _saveHabits();
  }

  void _deleteHabit(Habit habit) {
    setState(() {
      _habits.remove(habit);
    });
    _saveHabits();
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
