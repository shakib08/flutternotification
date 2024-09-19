import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification/screens/login.dart';
import 'package:notification/screens/notificationservice.dart'; // Import the login screen

class Home extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  TextEditingController recipientController = TextEditingController();
  TextEditingController messageController = TextEditingController();

 Future<void> sendMessage(BuildContext context) async {
  String recipientEmail = recipientController.text.trim();
  String messageText = messageController.text.trim();

  if (recipientEmail.isEmpty || messageText.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Please fill out all fields."),
    ));
    return;
  }

  User? currentUser = _auth.currentUser;

  if (currentUser != null) {
    try {
      // Debugging print statements
      print('Recipient Email: $recipientEmail');
      print('Message Text: $messageText');

      // Get the recipient's FCM token from Firestore
      var recipientSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: recipientEmail)
          .get();

      // Debugging: Print the retrieved documents
      print('Recipient Snapshot Docs: ${recipientSnapshot.docs}');

      if (recipientSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Recipient not found."),
        ));
        return;
      }

      // Extract the recipient's FCM token from the document
      var recipientDoc = recipientSnapshot.docs[0].data();
      String? recipientFcmToken = recipientDoc['token'] as String?;

      // Debugging: Print the extracted token
      print('Recipient FCM Token: $recipientFcmToken');

      if (recipientFcmToken == null || recipientFcmToken.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Recipient's FCM token is missing or invalid."),
        ));
        return;
      }

      // Store the message in Firestore
      await _firestore.collection('messages').add({
        'sender': currentUser.email,
        'receiver': recipientEmail,
        'message': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Create an instance of NotificationService
      NotificationService notificationService = NotificationService();

      // Obtain the access token
      String accessToken = await notificationService.getAccessToken();

      // Send a notification to the recipient using FCM
      await notificationService.sendNotification(
        accessToken,
        recipientFcmToken,
        'New Message from ${currentUser.email}', // Title
        messageText, // Body
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Message sent and notification triggered!"),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to send message: $e"),
      ));
    }
  }
}

  Future<void> logoutUser(BuildContext context) async {
    await _auth.signOut(); // Sign the user out from Firebase Auth

    // Navigate back to login page after logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()), // Go to Login page
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the current logged-in user
    User? currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              logoutUser(context); // Call logout when pressed
            },
          ),
        ],
      ),
      body: Center(
        child: currentUser != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome, ${currentUser.email}!",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: recipientController,
                    decoration: InputDecoration(
                      hintText: 'Recipient Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      sendMessage(context); // Call sendMessage when pressed
                    },
                    child: Text('Send Message'),
                  ),
                ],
              )
            : Text("No user is logged in."),
      ),
    );
  }
}
