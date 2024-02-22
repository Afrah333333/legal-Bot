import 'package:dialogflow_flutter/dialogflowFlutter.dart';

import 'knowledgebase.dart';

class QueryResult {
  String? queryText;
  String? action;
  Map? parameters;
  bool? allRequiredParamsPresent;
  String? fulfillmentText;
  List<dynamic>? fulfillmentMessages;
  Intent? intent;
  KnowledgeAnswers? knowledgeAnswers; // Add this field

  QueryResult(Map data) {
    queryText = data["queryText"];
    action = data["action"];
    parameters = data["parameters"] ?? null;
    allRequiredParamsPresent = data["allRequiredParamsPresent"];
    fulfillmentText = data["fulfillmentText"];
    intent = data['intent'] != null ? new Intent(data['intent']) : null;
    fulfillmentMessages = data['fulfillmentMessages'];
    knowledgeAnswers = data['knowledgeAnswers'] != null ? KnowledgeAnswers.fromJson(data['knowledgeAnswers']) : null; // Initialize knowledgeAnswers if available
  }
}
