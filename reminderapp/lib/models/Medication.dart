class Medication {
  final String name;
  final String dosage;
  final String frequency;
  final String imageAssetPath;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.imageAssetPath,
  });

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
        name: map['name'],
        dosage: map['dosage'],
        frequency: map['frequency'],
        imageAssetPath: "images/Aspirin.png"
        // Optionally handle missing fields or provide defaults
        );
  }
}
