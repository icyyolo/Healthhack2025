import 'package:flutter/material.dart';

class TranscriptPage extends StatelessWidget {
  final String username;

  TranscriptPage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'View Transcript',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
        ),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Transcript for $username: ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 10),
              Text(
                'From Dr Jon: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc tristique sapien elementum, vehicula urna a, imperdiet erat. Cras ornare ut velit a vehicula. Etiam volutpat leo ac libero molestie tincidunt. \n\nCras mollis massa quis lorem luctus feugiat. Pellentesque euismod neque nec ex iaculis egestas ut ut ipsum. Ut quis purus lorem. Pellentesque accumsan suscipit pharetra. \n\nPraesent lectus nibh, sagittis in mattis id, rutrum quis sapien.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 20),
              // Add more content here to test scrolling

            ],
          ),
        ),
      ),
    );
  }
}