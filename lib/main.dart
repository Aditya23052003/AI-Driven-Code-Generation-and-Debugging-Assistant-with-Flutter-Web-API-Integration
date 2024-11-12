import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

// Function for AI Code Generation and Debugging (mock function)
String generateCode(String description) {
  if (description.contains("reverse string")) {
    return '''
def reverse_string(s):
    return s[::-1]
    ''';
  } else if (description.contains("debug")) {
    return '''
# Fixed bug: infinite loop
while True:
    print("Hello World")
    break  # Added break to avoid infinite loop
    ''';
  }
  return "Code generation failed. Description unclear.";
}

// Dart-based server for handling requests (same project)
Future<void> startServer() async {
  final router = Router()
    ..post('/generate', (Request request) async {
      final body = await request.readAsString();
      final description = jsonDecode(body)['description'] as String;
      final code = generateCode(description);
      return Response.ok(code, headers: {'Content-Type': 'application/json'});
    });

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(router);
  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Server running at http://${server.address.host}:${server.port}');
}

// Flutter Web UI to interact with the backend
void main() {
  runApp(MyApp());

  // Start the backend server when the app runs
  startServer();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Code Assistant',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CodeAssistantPage(),
    );
  }
}

class CodeAssistantPage extends StatefulWidget {
  @override
  _CodeAssistantPageState createState() => _CodeAssistantPageState();
}

class _CodeAssistantPageState extends State<CodeAssistantPage> {
  String codeOutput = '';
  final TextEditingController _controller = TextEditingController();

  // Function to send a request to the backend for code generation
  Future<void> generateCode(String description) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'description': description}),
    );

    if (response.statusCode == 200) {
      setState(() {
        codeOutput = response.body;
      });
    } else {
      setState(() {
        codeOutput = 'Error generating code';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Code Assistant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Describe the task'),
              onSubmitted: (value) => generateCode(value),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                generateCode(_controller.text);
              },
              child: Text('Generate Code'),
            ),
            SizedBox(height: 20),
            Text('Generated Code:'),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SelectableText(codeOutput),
            ),
          ],
        ),
      ),
    );
  }
}
