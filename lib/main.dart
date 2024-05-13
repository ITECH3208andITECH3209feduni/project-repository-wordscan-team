import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Scanner App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  File? _imageFile;
  String _scannedText = '';
  int _sightWordCount = 0;
  int _nonSightWordCount = 0;

  // Define the list of sight words (the first 100 words)
  final List<String> sightWords = [
    'a', 'about', 'all', 'am', 'an', 'and', 'are', 'as', 'at', 'away',
    'back', 'be', 'been', 'big', 'black', 'blue', 'brown', 'but', 'by',
    'came', 'can', 'come', 'could', 'did', 'do', 'down', 'eat', 'find',
    'for', 'from', 'funny', 'get', 'go', 'good', 'green', 'had', 'has',
    'have', 'he', 'help', 'her', 'here', 'him', 'his', 'I', 'in', 'into',
    'is', 'it', 'jump', 'like', 'little', 'look', 'made', 'make', 'me',
    'my', 'not', 'now', 'of', 'on', 'one', 'or', 'out', 'play', 'put',
    'red', 'run', 'said', 'saw', 'say', 'see', 'she', 'so', 'some', 'stop',
    'take', 'that', 'the', 'their', 'them', 'then', 'there', 'they', 'this',
    'to', 'too', 'two', 'under', 'up', 'us', 'want', 'was', 'we', 'went',
    'what', 'white', 'who', 'will', 'with', 'yellow', 'yes', 'you', 'your'
  ];
//a
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _scannedText = ''; // Reset scanned text when a new image is selected
        _sightWordCount = 0; // Reset sight word count
        _nonSightWordCount = 0; // Reset non-sight word count
      });
      _processImage();
    }
  }

  Future<void> _processImage() async {
    final inputImage = InputImage.fromFilePath(_imageFile!.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    String extractedText = recognizedText.text;

    // Split the scanned text into words
    List<String> words = extractedText.split(' ');

    // Check if each word is a sight word or not
    for (int i = 0; i < words.length; i++) {
      if (sightWords.contains(words[i].toLowerCase())) {
        setState(() {
          _sightWordCount++; // Increment sight word count
        });
      } else {
        setState(() {
          _nonSightWordCount++; // Increment non-sight word count
        });
      }
    }

    setState(() {
      _scannedText = extractedText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Text Recognition App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _imageFile == null
                  ? const Text(
                'Select an image to analyze.',
                style: TextStyle(fontSize: 20),
              )
                  : Column(
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      children: _scannedText.isEmpty ? [] : _buildTextSpans(_scannedText),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sight Words: $_sightWordCount',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Non-Sight Words: $_nonSightWordCount',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ], // Close the children list of the Column widget
              ), // Close the Column widget
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                child: const Text('Pick Image', style: TextStyle(fontSize: 18)),
              ),
            ], // Close the children list of the Column widget
          ), // Close the Column widget
        ), // Close the SingleChildScrollView widget
      ), // Close the body property of Scaffold
    ); // Close the Scaffold widget
  } // Close the build method

  List<TextSpan> _buildTextSpans(String text) {
    List<TextSpan> spans = [];
    List<String> words = text.split(' ');

    for (String word in words) {
      if (sightWords.contains(word.toLowerCase())) {
        spans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blue, // Highlight color for sight words
              fontWeight: FontWeight.bold, // Optionally, make the text bold
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(fontSize: 12),
          ),
        );
      }
    }

    return spans;
  }
}