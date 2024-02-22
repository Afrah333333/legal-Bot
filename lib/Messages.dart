import 'dart:convert';
import 'package:dialogflow_flutter/message.dart';


import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/language.dart';
import 'package:dialogflow_flutter/message.dart';
import 'package:flutter/material.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';

import 'advanced_bot.dart';
import 'knowledgebase.dart';

class FlutterFactsChatBot extends StatefulWidget {
  FlutterFactsChatBot({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _FlutterFactsChatBotState createState() => new _FlutterFactsChatBotState();
}

class _FlutterFactsChatBotState extends State<FlutterFactsChatBot> {
  final List<Facts> messageList = <Facts>[];
  final TextEditingController _textController = new TextEditingController();

  Widget _queryInputWidget(BuildContext context) {
    return Card(
      color: Colors.orange.shade200,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.only(left:8.0, right: 8),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _submitQuery,
                decoration: InputDecoration.collapsed(hintText: "Send greeting message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send, color: Colors.orange.shade700,),
                  onPressed: () => _submitQuery(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  void agentResponse(String query) async {
    _textController.clear();

    try {
      AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/legalbot-gobv-ae52498c4c83.json").build();
      DialogFlow dialogFlow = DialogFlow(authGoogle: authGoogle, language: Language.english);
      AIResponse response = await dialogFlow.detectIntent(query);

      print('DialogFlow Response: $response');

      final queryResult = response.queryResult;
      if (queryResult != null) {
        String? fulfillmentText = queryResult.fulfillmentText;
        String? documentUrl = queryResult.parameters?['documentUrl'];
        print('Received Document URL: $documentUrl');

        if (fulfillmentText != null && fulfillmentText.isNotEmpty) {
          Facts message = Facts(
            text: fulfillmentText,
            type: false,
            name: 'Bot',
            documentUrl: documentUrl ?? '',
          );

          setState(() {
            messageList.insert(0, message);
          });
        } else {
          print('No response from DialogFlow');
        }
      } else {
        print('Error: Invalid response structure from DialogFlow');
      }
    } catch (e, stacktrace) {
      print('Error during DialogFlow request: $e\n$stacktrace');
    }
  }



  void _submitQuery(String text) {
    _textController.clear();
    Facts message = new Facts(
      text: text,
      name: "You",
      type: true,
    );
    setState(() {
      messageList.insert(0, message);
    });
    agentResponse(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LEGALBOT ⚖️ ", style: TextStyle(color: Colors.orange[700]),),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true, //To keep the latest messages at the bottom
              itemBuilder: (_, int index) => messageList[index],
              itemCount: messageList.length,
            )),
        _queryInputWidget(context),
      ]),
    );
  }
}