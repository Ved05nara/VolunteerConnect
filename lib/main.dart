import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/opportunities_screen.dart';
import 'screens/how_to_join_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(const VolunteerConnectApp());
}

class VolunteerConnectApp extends StatelessWidget {
  const VolunteerConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VolunteerConnect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = <Widget>[
    OpportunitiesScreen(),
    HowToJoinScreen(),
    AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Opportunities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_reg),
            label: 'How to Join',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),
    );
  }
}