# Project

A new Flutter project of sending and receiving notifications between two users.

## Project Description

It's a basic flutter task managing the notification between two users. Flutter needs permission from android manifest for managing the notification. Besides device token must be needed to send the notification in flutter. In this project I have implemented both. The permissions I had to gave in android manifest are 

<ul>
  <li>Fcm token permission over internet</li>
  <li>Fcm token permission over WAKE_LOCK</li>
  <li>Fcm token permission over RECEIVE_BOOT_COMPLETED</li>
  <li>Fcm token permission over FOREGROUND_SERVICE</li>
</ul>

## Database
I have used firebase firestore database for the realtime database and for authentication I have used firebase auth. 

## Working methodology
In the initial sign up, I have taken the device token from the user and store it to the firestore collection. And then when user try to login, then also I am taking the fcm token from the user and match with the token which is stored to the firestore collection. If both the token match, then it will remain same, but if the tokens don't match, the current token will be updated and stored to the firestore database and managing the notification receive and get. 
