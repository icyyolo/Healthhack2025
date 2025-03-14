import 'package:flutter/material.dart';
import '../widgets/message_bubble.dart'; // Adjust the import path as needed
import '../models/Medication.dart'; // Import the Medication class
import 'settings_page.dart';
import 'transcript_page.dart';

class CustomDrawer extends StatelessWidget {
  final String username;
  final List<Medication> medications;
  final Function(String) showMedicationImage;

  const CustomDrawer({
    required this.username,
    required this.medications,
    required this.showMedicationImage,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        username,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: const Text('View Transcript',
                      style: TextStyle(
                          fontFamily: 'Inter', fontWeight: FontWeight.w300)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TranscriptPage(username: username),
                      ),
                    );
                  },
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Medications',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...medications.map((medication) {
                  return GestureDetector(
                    onTap: () {
                      showMedicationImage(medication.imageAssetPath);
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Next Dose:',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '3pm', // Replace with actual next dose time if available
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Image.asset(
                                  medication.imageAssetPath,
                                  width: 50,
                                  height: 50,
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      medication.name,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${medication.dosage} • ${medication.frequency}',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Divider(),
          ListTile(
            title: const Text('Settings',
                style: TextStyle(
                    fontFamily: 'Inter', fontWeight: FontWeight.w300)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(username: username),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
