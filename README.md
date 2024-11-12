# AI-Driven-Code-Generation-and-Debugging-Assistant-with-Flutter-Web-API-Integration

ai_code_assistant/
├── backend/
│   ├── lib/
│   │   └── server.dart
│   ├── pubspec.yaml
├── frontend/
│   ├── lib/
│   │   └── main.dart
│   ├── pubspec.yaml

or

ai_code_assistant/
├── lib/
│   ├── main.dart
├── pubspec.yaml

Dart Backend:

The startServer() function initializes the Dart backend using the Shelf package. It listens for POST requests at /generate to process the code generation logic.
The generateCode function is a simple mock function that generates code based on keywords in the description (you can replace this with a call to an actual AI model such as GPT-3).
Flutter Web Frontend:

The Flutter app uses a TextField where the user can enter a description of the task (e.g., "reverse a string").
When the user submits the description, the generateCode function sends a POST request to the local server (localhost:8080/generate).
The response from the server, which contains the generated code, is displayed in the app.
Running the Project:

When the app is launched using flutter run -d chrome, the backend server starts automatically within the same project.
The frontend interacts with this local server to perform code generation.


Running the Project
Step 1: Install dependencies by running the following command in the project root directory:
flutter pub get

Step 2: Run the Flutter Web app using:
flutter run -d chrome
This will start both the backend server and the Flutter frontend.

Step 3: Open your browser (usually http://localhost:8000), and the app should load. You can then input code generation descriptions and view the generated code.
