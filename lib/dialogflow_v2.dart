import 'package:meta/meta.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import "package:googleapis/dialogflow/v2.dart";
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Dialogflow {
  late String serviceAccountPath;

  late auth.ServiceAccountCredentials credentials;
  late auth.AuthClient sessionClient;
  late DialogflowApi df;
  late String projectId;

  /// Create a Dialogflow instance
  // /
  // / ```
  // df = Dialogflow(serviceAccountPath: "assets/credentials.json");
  // / var sessionPath = await df.getSession();
  // / var request = Dialogflow.getRequestTextInput(query, "en-US");
  // / var response = await df.detectIntent(request, sessionPath);
  // /
  // / print(response.queryResult.fulfillmentText);
  // / ```
  Dialogflow({ required this.serviceAccountPath});

  Future<String> getSession() async {
    const scopes = ["https://www.googleapis.com/auth/cloud-platform"];
    // Load the service account the specified path (see pubspec.yaml)
    String jsonCredentials = await _getJsonCredentials(this.serviceAccountPath);
    // Set the projectId
    Map jsonData = json.decode(jsonCredentials);
    this.projectId = jsonData['project_id'];

    try{
      // Get the credentials from the service account json file
      this.credentials = auth.ServiceAccountCredentials.fromJson(jsonCredentials);
      // Create an authentication client
      auth.AuthClient client = await auth.clientViaServiceAccount(this.credentials, scopes);
      // Set the Dialogflow API instance
      this.df = DialogflowApi(client);
    } catch (e) {
      print(e);
    }

    // Return the full Session path
    return this._getSessionPath();
  }

  // Build a Dialogflow Text request
  static GoogleCloudDialogflowV2DetectIntentRequest getRequestTextInput(String msg, String lang){
    // Create a text input
    final inputText = GoogleCloudDialogflowV2TextInput()
      ..text = msg
      ..languageCode = lang;

    // Assign the inputText to the queryInput
    final queryInput = GoogleCloudDialogflowV2QueryInput()
      ..text = inputText;

    // Get the rest of the request
    GoogleCloudDialogflowV2DetectIntentRequest request = _getRequest(queryInput);

    return request;
  }

  // Build a Dialogflow Audio request
  static detectAudioStream(String msg){
    //TODO
  }

  Future<GoogleCloudDialogflowV2DetectIntentResponse> detectIntent(GoogleCloudDialogflowV2DetectIntentRequest request, String sessionPath) async {
    // Get a session URL for detectIntent call
    var session = "$sessionPath:detectIntent";
    final response = await this.df.projects.agent.sessions.detectIntent(request, session);
    return response;
  }

  String _getSessionPath() {
    // Get a session path with a unique session id
    var sessionId = new Uuid().v4();
    return "projects/${this.projectId}/agent/sessions/$sessionId";
  }

  Future<String> _getJsonCredentials(String path) async {
    var response;
    try{
      // Read the credentials from the JSON file as a String
      response = await rootBundle.loadString(path);
    } catch (e) {
      print(e);
    }
    return response;
  }

  static GoogleCloudDialogflowV2DetectIntentRequest _getRequest(GoogleCloudDialogflowV2QueryInput queryInput) {
    // Build the request
    final request = new GoogleCloudDialogflowV2DetectIntentRequest()
      ..queryInput = queryInput;

    return request;
  }
}