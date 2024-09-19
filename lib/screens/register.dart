import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Request notification permission when the widget initializes
    requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    // Request notification permissions (iOS specific, Android usually grants by default)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission for notifications.');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission for notifications.');
    } else {
      print('User declined or has not accepted permission for notifications.');
    }
  }

  Future<void> registerUser() async {
    try {
      // Register the user with Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // Get the user's UID (unique identifier)
      String uid = userCredential.user!.uid;

      // Check if notification permission was granted before getting FCM token
      NotificationSettings settings = await _firebaseMessaging.getNotificationSettings();

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Get the device's FCM token
        String? token = await _firebaseMessaging.getToken();

        if (token != null) {
          // Store additional user data and token in Firestore with the UID as the document ID
          await _firestore.collection('users').doc(uid).set({
            'name': name.text.trim(),
            'email': email.text.trim(),
            'password': password.text.trim(),
            'token': token, // Store the FCM token
            'createdAt': FieldValue.serverTimestamp(),
          });

          // Display success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("User registered successfully and token saved!"),
          ));
        } else {
          // Handle case where token is null
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Permission granted, but no token was generated."),
          ));
        }
      } else {
        // Handle case where permission was denied
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Permission denied. No FCM token generated."),
        ));

        // You can still store user data without the token if needed
        await _firestore.collection('users').doc(uid).set({
          'name': name.text.trim(),
          'email': email.text.trim(),
          'password': password.text.trim(),
          'token': null, // No token since permission was denied
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // Handle any errors during registration
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: name, // Assigning the controller to the TextField
              decoration: InputDecoration(
                hintText: 'Name',
                prefixIcon: Icon(Icons.person), // Name icon
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded rectangle border
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.blue), // Border color when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey), // Default border color
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: email, // Assigning the controller to the TextField
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email), // Email icon
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded rectangle border
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.blue), // Border color when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey), // Default border color
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: password, // Assigning the controller to the TextField
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock), // Lock icon
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded rectangle border
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.blue), // Border color when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey), // Default border color
                ),
              ),
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: registerUser, // Register the user when pressed
              child: Text("Register"),
            ),
            SizedBox(height: 20),
            Text("Already have an account?"),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate to the login page
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
