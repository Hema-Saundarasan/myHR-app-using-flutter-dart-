import 'package:flutter/material.dart';
import 'database_helper.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController employeeNameController = TextEditingController();
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController reasonController = TextEditingController();

  String leaveType = "Annual Leave";

  DateTime? startDate;
  DateTime? endDate;

  Future<void> selectStartDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => startDate = picked);
    }
  }

  Future<void> selectEndDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  Future<void> submitLeave() async {
    if (!_formKey.currentState!.validate()) return;

    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select start and end dates")),
      );
      return;
    }

    await DatabaseHelper.instance.insertLeave({
      "employee_name": employeeNameController.text,
      "employee_id": employeeIdController.text,
      "leave_type": leaveType,
      "reason": reasonController.text,
      "date":
          "${startDate.toString().substring(0, 10)} - ${endDate.toString().substring(0, 10)}",
      "status": "Pending",
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Leave Request Submitted"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    employeeNameController.clear();
    employeeIdController.clear();
    reasonController.clear();

    setState(() {
      startDate = null;
      endDate = null;
      leaveType = "Annual Leave";
    });
  }

  @override
  void dispose() {
    employeeNameController.dispose();
    employeeIdController.dispose();
    reasonController.dispose();
    super.dispose();
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
                  "Leave Application",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Form(
                      key: _formKey,

                      child: Column(
                        children: [
                          TextFormField(
                            controller: employeeNameController,
                            decoration: const InputDecoration(
                              labelText: "Employee Name",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Required" : null,
                          ),

                          const SizedBox(height: 15),

                          TextFormField(
                            controller: employeeIdController,
                            decoration: const InputDecoration(
                              labelText: "Employee ID",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Required" : null,
                          ),

                          const SizedBox(height: 15),

                          DropdownButtonFormField(
                            value: leaveType,
                            items: const [
                              DropdownMenuItem(
                                value: "Annual Leave",
                                child: Text("Annual Leave"),
                              ),
                              DropdownMenuItem(
                                value: "Medical Leave",
                                child: Text("Medical Leave"),
                              ),
                              DropdownMenuItem(
                                value: "Emergency Leave",
                                child: Text("Emergency Leave"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() => leaveType = value!);
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: selectStartDate,
                                  child: Text(
                                    startDate == null
                                        ? "Start Date"
                                        : startDate!
                                            .toString()
                                            .substring(0, 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: selectEndDate,
                                  child: Text(
                                    endDate == null
                                        ? "End Date"
                                        : endDate!
                                            .toString()
                                            .substring(0, 10),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          TextFormField(
                            controller: reasonController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: "Reason",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Required" : null,
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: submitLeave,
                              child: const Text("Submit Leave"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}