import 'package:flutter/material.dart';
import 'database_helper.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String status = "Not Clocked In";
  String clockInTime = "-";
  String clockOutTime = "-";
  bool alreadyClockedIn = false;

  List<Map<String, dynamic>> attendanceHistory = [];
  List<Map<String, dynamic>> leaveRequests = [];
  List<Map<String, dynamic>> employees = [];

  int totalAttendance = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final attendance =
        await DatabaseHelper.instance.getAttendance();

    final leaves =
        await DatabaseHelper.instance.getLeaveRequests();

    final emp =
        await DatabaseHelper.instance.getEmployees();

    setState(() {
      attendanceHistory = attendance;
      leaveRequests = leaves;
      employees = emp;

      totalAttendance = attendance
          .where((item) => item["action"] == "Clock In")
          .length;
    });
  }

  Future<void> clockIn() async {
    if (alreadyClockedIn) return;

    final time = DateTime.now().toString().substring(0, 19);

    await DatabaseHelper.instance.insertAttendance(
      "Clock In",
      time,
    );

    setState(() {
      clockInTime = time;
      status = "Clocked In";
      alreadyClockedIn = true;
    });

    loadData();
  }

  Future<void> clockOut() async {
    final time = DateTime.now().toString().substring(0, 19);

    await DatabaseHelper.instance.insertAttendance(
      "Clock Out",
      time,
    );

    setState(() {
      clockOutTime = time;
      status = "Clock Out";
    });

    loadData();
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
              const SizedBox(height: 20),

              const Text(
                "Attendance",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "$totalAttendance Employees Clocked In",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status: $status"),
                      Text("Clock In: $clockInTime"),
                      Text("Clock Out: $clockOutTime"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: clockIn,
                child: const Text("Clock In"),
              ),

              ElevatedButton(
                onPressed: clockOut,
                child: const Text("Clock Out"),
              ),

              const SizedBox(height: 20),

              const Text(
                "Attendance History",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              ...attendanceHistory.map((e) {
                return Card(
                  child: ListTile(
                    title: Text(e["action"]),
                    subtitle: Text(e["time"]),
                  ),
                );
              }),

              const SizedBox(height: 25),

              const Text(
                "Leave Applications",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (leaveRequests.isEmpty)
                const Card(
                  child: ListTile(
                    title: Text("No Leave Applications"),
                  ),
                ),

              ...leaveRequests.map((e) {
                return Card(
                  child: ListTile(
                    title: Text(e["employee_name"] ?? ""),
                    subtitle: Text(
                      "${e["employee_id"]} | ${e["reason"]}",
                    ),
                    trailing: Text(e["status"] ?? ""),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    ),
  );
}
}