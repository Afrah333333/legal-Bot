import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '';

class Facts extends StatelessWidget {
  Facts({required this.text, required this.name, required this.type,this.documentUrl = ''});

  final String text;
  final String name;
  final bool type;
  final String documentUrl;




  List<Widget> botMessage(BuildContext context) {
    // Regular expression to match URLs ending with '.docx'
    RegExp regex = RegExp(r'https:\/\/.*\.docx\b');

    // Extract document URL from the text
    String extractedUrl = '';
    String displayText = text;
    Match? match = regex.firstMatch(text);
    if (match != null) {
      extractedUrl = match.group(0)!;
      // Remove the extracted URL from the display text
      displayText = text.replaceAll(extractedUrl, '');
    }

    List<Widget> messageWidgets = [
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: CircleAvatar(
          backgroundColor: Colors.orange.shade200,
          child: Text('B'),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayText), // Display text without the URL
            if (extractedUrl.isNotEmpty) // Conditionally display the download button
              ElevatedButton(style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange.shade700),
              ),
                onPressed: () {
                  launchUrl(Uri.parse(extractedUrl));
                },
                child: Text('Download Document',
                  style:TextStyle(color: Colors.black) ,),
              ),
          ],
        ),
      ),
    ];

    return messageWidgets;
  }


  List<Widget> userMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(this.name, style: Theme.of(context).textTheme.subtitle1),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: new Text(text),
            ),
          ],
        ),
      ),
      new Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: new CircleAvatar(
          backgroundColor: Colors.orange.shade200,
            child: new Text(
              this.name[0],
              style: new TextStyle(fontWeight: FontWeight.bold),
            )),
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? userMessage(context) : botMessage(context),
      ),
    );
  }
}