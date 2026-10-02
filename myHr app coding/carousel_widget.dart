import 'package:flutter/material.dart';
import 'database_helper.dart';

ValueNotifier<int> announcementRefresh = ValueNotifier(0);

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  List<Map<String, dynamic>> announcements = [];

  @override
  void initState() {
    super.initState();
    loadAnnouncements();

    announcementRefresh.addListener(() {
      loadAnnouncements();
    });
  }

  Future<void> loadAnnouncements() async {
    final data = await DatabaseHelper.instance.getAnnouncements();

    setState(() {
      announcements = data;
    });
  }

  Icon getIcon(int index) {
    final icons = [
      Icons.groups,
      Icons.account_balance_wallet,
      Icons.event,
      Icons.warning,
      Icons.campaign,
    ];

    return Icon(
      icons[index % icons.length],
      color: Colors.white,
      size: 50,
    );
  }

  @override
  void dispose() {
    announcementRefresh.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,

      child: announcements.isEmpty
          ? const Card(
              color: Colors.blue,
              child: Center(
                child: Text(
                  "No Announcements",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              itemCount: announcements.length,

              itemBuilder: (context, index) {
                final item = announcements[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        getIcon(index),

                        const SizedBox(height: 15),

                        Text(
                          item["title"] ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          item["message"] ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}