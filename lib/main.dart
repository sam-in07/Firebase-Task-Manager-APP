import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async   {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  // Connect With My Firebase Task Collection
  final tasksRef = FirebaseFirestore.instance.collection('task collection');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Task App")),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: tasksRef.snapshots(),
        builder: (context, snapshot) {
          // 1. Handle waiting state (show spinner while loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Handle errors
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // 3. Handle no data (snapshot is null or documents list is empty)
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No tasks found. Add a task in Firestore.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();

              // FIX: Safely retrieve 'name' using null-coalescing (??) operator.
              // This ensures that if data['name'] is null, 'No Name' is used instead,
              // preventing the "type 'Null' is not a subtype of type 'String'" error.
              final name = (data['name'] as String?) ?? 'No Name';

              return ListTile(title: Text(name));
            },
          );
        },
      ),
    );
  }
}