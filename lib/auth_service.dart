import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart'; // Import from auth_io.dart
import 'package:googleapis_auth/googleapis_auth.dart';

Future<String> getAccessToken() async {
  // Load the JSON from assets instead of a local file path
  final rawJson = await rootBundle.loadString('assets/service_account.json');

  // Create credentials from the JSON string
  var credentials = ServiceAccountCredentials.fromJson(rawJson);

  // Define the scopes required for Dialogflow
  var scopes = ['https://www.googleapis.com/auth/cloud-platform'];

  // Obtain an authenticated HTTP client
  var client = await clientViaServiceAccount(credentials, scopes);

  // Extract the access token
  String token = client.credentials.accessToken.data;

  // Close the client
  client.close();

  return token;
}
