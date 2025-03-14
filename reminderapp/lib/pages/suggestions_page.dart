import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/suggestions.dart';

class SuggestionsPage extends StatefulWidget {
  final String username;

  const SuggestionsPage({required this.username});

  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  late final ApiService _apiService;
  List<Suggestion> suggestions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    fetchSuggestions();
  }

  void fetchSuggestions() async {
    try {
      List<Suggestion> fetchedSuggestions =
          await _apiService.getSuggestions(widget.username);

      setState(() {
        suggestions = fetchedSuggestions;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching suggestions: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suggestions"),
        backgroundColor: Colors.grey,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                Suggestion suggestion = suggestions[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          suggestion.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          suggestion.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
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
