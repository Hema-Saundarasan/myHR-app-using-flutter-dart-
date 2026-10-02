import 'package:flutter/material.dart';
import 'carousel_widget.dart';
import 'database_helper.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  List<Map<String, dynamic>> announcements = [];

  @override
  void initState() {
    super.initState();
    loadAnnouncements();
  }

  Future<void> loadAnnouncements() async {
    final data = await DatabaseHelper.instance.getAnnouncements();
    setState(() {
      announcements = data;
    });
  }

  Future<void> addAnnouncement() async {
    if (titleController.text.isEmpty || messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    await DatabaseHelper.instance.insertAnnouncement(
      titleController.text,
      messageController.text,
    );

    titleController.clear();
    messageController.clear();

    await loadAnnouncements();

    // refresh carousel
    announcementRefresh.value++;

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Announcement Added")),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("Announcements"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              const Text(
                "Company News & Events",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const CarouselWidget(),

              const SizedBox(height: 25),

              const Text(
                "Add Announcement",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addAnnouncement,
                  child: const Text("Add Announcement"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}