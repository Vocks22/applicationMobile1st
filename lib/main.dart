import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/services_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(const InfIAApp());
}

class InfIAApp extends StatelessWidget {
  const InfIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INF-IA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.system,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  static void navigateTo(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainNavigationState>();
    state?.setIndex(index);
  }

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    ServicesScreen(),
    StatsScreen(),
    ContactScreen(),
    AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined),
            selectedIcon: Icon(Icons.business),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'IA Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.mail_outlined),
            selectedIcon: Icon(Icons.mail),
            label: 'Contact',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outlined),
            selectedIcon: Icon(Icons.info),
            label: 'A propos',
          ),
        ],
      ),
    );
  }
}
