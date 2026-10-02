import 'package:flutter/material.dart';
import 'database_helper.dart';

class EntryApprovalPage extends StatefulWidget {
  const EntryApprovalPage({super.key});

  @override
  State<EntryApprovalPage> createState() =>
      _EntryApprovalPageState();
}

class _EntryApprovalPageState extends State<EntryApprovalPage> {
  String selectedType = "User";

  List<Map<String, dynamic>> leaveRequests = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadLeaveRequests();
  }

  Future<void> loadLeaveRequests() async {
    final data = await DatabaseHelper.instance.getLeaveRequests();

    setState(() {
      leaveRequests = data;
    });
  }

  Future<void> addEmployee() async {
    if (nameController.text.isEmpty ||
        idController.text.isEmpty ||
        departmentController.text.isEmpty ||
        positionController.text.isEmpty ||
        emailController.text.isEmpty ||
        experienceController.text.isEmpty ||
        statusController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all employee fields")),
      );
      return;
    }

    await DatabaseHelper.instance.insertEmployee({
      "employee_name": nameController.text,
      "employee_id": idController.text,
      "department": departmentController.text,
      "position": positionController.text,
      "email": emailController.text,
      "experience": experienceController.text,
      "status": statusController.text,
    });

    nameController.clear();
    idController.clear();
    departmentController.clear();
    positionController.clear();
    emailController.clear();
    experienceController.clear();
    statusController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Employee Added Successfully")),
    );
  }

  Future<void> addTask() async {
    if (taskController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter task title")),
      );
      return;
    }

    await DatabaseHelper.instance.insertTask(taskController.text);

    taskController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task Added Successfully")),
    );
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
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
               " Data Entry & Approval",
                style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

              const SizedBox(height: 20),

              // ================= CARD =================
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Add Data",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 15),

                      DropdownButtonFormField(
                        value: selectedType,
                        items: const [
                          DropdownMenuItem(
                            value: "User",
                            child: Text("User"),
                          ),
                          DropdownMenuItem(
                            value: "Task",
                            child: Text("Task"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                        decoration: inputStyle("Select Type"),
                      ),

                      const SizedBox(height: 15),

                      // ================= USER FORM =================
                      if (selectedType == "User") ...[
                        TextField(
                          controller: nameController,
                          decoration: inputStyle("Employee Name"),
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: idController,
                          decoration: inputStyle("Employee ID"),
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: departmentController,
                          decoration: inputStyle("Department"),
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: positionController,
                          decoration: inputStyle("Position"),
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: emailController,
                          decoration: inputStyle("Email"),
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: experienceController,
                          decoration: inputStyle("Experience"),
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: statusController,
                          decoration: inputStyle("Status"),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: addEmployee,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Add Employee"),
                          ),
                        ),
                      ],

                      // ================= TASK FORM =================
                      if (selectedType == "Task") ...[
                        TextField(
                          controller: taskController,
                          decoration: inputStyle("Task Title"),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: addTask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Add Task"),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ================= LEAVE SECTION =================
              const Text(
                "Leave Approval",
                style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                ),
              ),

              const SizedBox(height: 10),

              if (leaveRequests.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text("No Leave Applications"),
                  ),
                ),

              ...leaveRequests.map((request) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request["employee_name"] ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text("Employee ID : ${request["employee_id"]}"),
                        Text("Reason : ${request["reason"]}"),
                        Text("Date : ${request["date"]}"),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Status : ${request["status"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await DatabaseHelper.instance
                                      .updateLeaveStatus(
                                    request["id"],
                                    "Approved",
                                  );
                                  loadLeaveRequests();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text("Approve"),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await DatabaseHelper.instance
                                      .updateLeaveStatus(
                                    request["id"],
                                    "Rejected",
                                  );
                                  loadLeaveRequests();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text("Reject"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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