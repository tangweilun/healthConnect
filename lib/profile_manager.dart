import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileManager extends StatefulWidget {
  @override
  _ProfileManagerState createState() => _ProfileManagerState();
}

class _ProfileManagerState extends State<ProfileManager> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _editManagerData(String documentId, Map<String, dynamic> newData) async {
    await _firestore.collection('manager').doc(documentId).update(newData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager Profile'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('manager').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}', style: TextStyle(fontSize: 20.0)),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No managers found.', style: TextStyle(fontSize: 20.0)),
            );
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              // Convert timestamp to DateTime
              DateTime dob = (data['dob'] as Timestamp).toDate();

              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data['name']}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      SizedBox(height: 8.0),
                      Text('Manager ID: ${data['manager_id']}', style: TextStyle(fontSize: 16.0)),
                      Text('Date of Birth: ${dob.day}/${dob.month}/${dob.year}', style: TextStyle(fontSize: 16.0)), // Format the date as needed
                      Text('Email: ${data['email']}', style: TextStyle(fontSize: 16.0)),
                      Text('Phone Number: ${data['phone_number']}', style: TextStyle(fontSize: 16.0)),
                      Text('Gender: ${data['gender']}', style: TextStyle(fontSize: 16.0)),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return EditManagerDialog(
                                managerData: data,
                                onEdit: (Map<String, dynamic> newData) {
                                  _editManagerData(document.id, newData);
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                        child: Text('Edit'),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class EditManagerDialog extends StatefulWidget {
  final Map<String, dynamic> managerData;
  final Function(Map<String, dynamic>) onEdit;

  EditManagerDialog({required this.managerData, required this.onEdit});

  @override
  _EditManagerDialogState createState() => _EditManagerDialogState();
}

class _EditManagerDialogState extends State<EditManagerDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.managerData['name']);
    _emailController = TextEditingController(text: widget.managerData['email']);
    _phoneNumberController = TextEditingController(text: widget.managerData['phone_number']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Manager'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Map<String, dynamic> newData = {
              'name': _nameController.text,
              'email': _emailController.text,
              'phone_number': _phoneNumberController.text,
            };
            widget.onEdit(newData);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
