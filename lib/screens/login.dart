import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notification/screens/home.dart';
import 'package:notification/screens/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController(); 
    TextEditingController password = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      // Navigate to home page upon successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()), // Home screen
      );
    } catch (e) {
      // Handle errors (e.g., invalid credentials)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              
             SizedBox(height: 10,),

              TextField(
                controller: password, // Assigning the controller to the TextField
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock), // Email icon
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
              SizedBox(height: 20,), 
              FloatingActionButton(
                onPressed: loginUser, 
                child: Text("Login"),
              ), 
              SizedBox(height: 20,),  

              Text("Don't have an account?"), 
              SizedBox(height: 10,), 
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
                },
                child: Text("Register"),
              )

          ],
        ),
      ),
    );
  }
}