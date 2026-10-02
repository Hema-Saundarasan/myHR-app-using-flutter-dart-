import 'package:flutter/material.dart';
import 'attendance_page.dart';
import 'leave_page.dart';
import 'entry_approval.dart';
import 'database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final data = await DatabaseHelper.instance.getTasks();
    setState(() {
      tasks = data;
    });
  }

  Future<void> updateTask(int id, bool checked) async {
    await DatabaseHelper.instance.updateTask(id, checked ? 1 : 0);
    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await DatabaseHelper.instance.deleteTask(id);
    loadTasks();
  }

  Widget quickActionCard({
    required IconData icon,
    required String label,
    required Widget page,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 10),

                const Text(
                  "Hi Adam 👋",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Text(
                  "Welcome to MyHR",
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),

                // ================= TASKS =================
                const Text(
                  "Pending Tasks",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),

                    child: tasks.isEmpty
                        ? const Text("No Tasks Available")
                        : Column(
                            children: tasks.map((task) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: task["checked"] == 1,
                                        onChanged: (value) async {
                                          await updateTask(task["id"], value!);
                                        },
                                      ),

                                      Expanded(
                                        child: Text(
                                          task["title"],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),

                                      ElevatedButton(
                                        onPressed: () async {
                                          if (task["checked"] == 1) {
                                            await deleteTask(task["id"]);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Please tick the checkbox first",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text("Done"),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              );
                            }).toList(),
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                // ================= QUICK ACTIONS =================
                const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // Row 1
                Row(
                  children: [
                    Expanded(
                      child: quickActionCard(
                        icon: Icons.access_time,
                        label: "Attendance",
                        page: const AttendancePage(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: quickActionCard(
                        icon: Icons.assignment,
                        label: "Leave",
                        page: const LeavePage(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Row 2 (centered)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.48,
                      child: quickActionCard(
                        icon: Icons.admin_panel_settings,
                        label: "Entry & Approval",
                        page: const EntryApprovalPage(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}