import 'package:flutter/material.dart';

import 'home.dart';
import 'attendance_page.dart';
import 'leave_page.dart';
import 'announcement.dart';
import 'profile.dart';
import 'entry_approval.dart';
import 'main.dart';

class ColumnPage extends StatefulWidget {
  const ColumnPage({super.key});

  @override
  State<ColumnPage> createState() => _ColumnPageState();
}

class _ColumnPageState extends State<ColumnPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const AttendancePage(),
    const LeavePage(),
    const AnnouncementPage(),
    const ProfilePage(),
  ];

  void selectPage(int index) {
    setState(() {
      currentIndex = index;
    });
    Navigator.pop(context); // close drawer
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MYHR"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      //  DRAWER 
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                "MYHR Menu",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => selectPage(0),
            ),

            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Attendance"),
              onTap: () => selectPage(1),
            ),

            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text("Leave"),
              onTap: () => selectPage(2),
            ),

            ListTile(
              leading: const Icon(Icons.campaign),
              title: const Text("News"),
              onTap: () => selectPage(3),
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () => selectPage(4),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.manage_accounts),
              title: const Text("Entry & Approval"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntryApprovalPage(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: logout,
            ),
          ],
        ),
      ),

      body: pages[currentIndex],

      // BOTTOM NAVIGATION 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Attendance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Leave",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: "News",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}