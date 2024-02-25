import 'package:flutter/material.dart';

// Sample data structure representing data from Firebase
class FirebaseData {
  final String id;
  final String name;
  final String description;

  FirebaseData({
    required this.id,
    required this.name,
    required this.description,
  });
}

// Sample list of data (replace this with data from Firebase)
final List<FirebaseData> firebaseDataList = [
  FirebaseData(id: '1', name: 'Item 1', description: 'Description 1'),
  FirebaseData(id: '2', name: 'Item 2', description: 'Description 2'),
  FirebaseData(id: '3', name: 'Item 3', description: 'Description 3'),
  // Add more data as needed
];

class ViewDepartments extends StatelessWidget {
  const ViewDepartments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Data'),
      ),
      body: ListView.builder(
        itemCount: firebaseDataList.length,
        itemBuilder: (context, index) {
          final data = firebaseDataList[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(data.name),
              subtitle: Text(data.description),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Handle delete functionality
                },
              ),
              onTap: () {
                // Handle item tap
              },
            ),
          );
        },
      ),
    );
  }
}
