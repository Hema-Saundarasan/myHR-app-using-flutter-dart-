import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Map<String, dynamic>> employees = [];

  @override
  void initState() {
    super.initState();
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    final data = await DatabaseHelper.instance.getEmployees();

    setState(() {
      employees = data;
    });
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
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              "Employee Directory",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              "View employee information",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: employees.isEmpty
                  ? const Center(child: Text("No Employees Found"))
                  : ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),

                            leading: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),

                            title: Text(
                              employee["employee_name"] ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Text(
                              "${employee["position"] ?? ""}\nStatus: ${employee["status"] ?? ""}",
                            ),

                            trailing: const Icon(Icons.arrow_forward_ios),

                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(
                                      employee["employee_name"] ?? "",
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Employee ID: ${employee["employee_id"]}",
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Department: ${employee["department"]}",
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Position: ${employee["position"]}",
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Email: ${employee["email"]}",
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Experience: ${employee["experience"]}",
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Status: ${employee["status"]}",
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text("Close"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 10),

            // ================= LOGOUT BUTTON =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}