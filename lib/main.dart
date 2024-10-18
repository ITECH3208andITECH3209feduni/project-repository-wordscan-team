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
      title: 'Text Recognition App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Set default font family
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
  final List<String> _selectedWordLists = ['100 Sight Words (List 1)'];

  final Map<String, List<String>> _availableWordLists = {
    '100 Sight Words (List 1)': [
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
    ],
    '100 Sight Words (List 2)': [
      'about', 'after', 'again', 'air', 'also', 'America', 'animal', 'another', 'answer', 'any',
      'are', 'ask', 'away', 'back', 'baseball', 'be', 'because', 'been', 'before', 'big',
      'bird', 'book', 'both', 'box', 'boy', 'but', 'by', 'call', 'came', 'can',
      'car', 'carry', 'change', 'children', 'city', 'close', 'come', 'could', 'country', 'cut',
      'day', 'did', 'different', 'do', 'does', 'dog', 'dollars', 'done', 'door', 'down',
      'draw', 'drink', 'each', 'early', 'earth', 'eat', 'eight', 'end', 'enough', 'even',
      'ever', 'every', 'example', 'eye', 'face', 'fact', 'fall', 'family', 'far', 'farm',
      'father', 'feet', 'few', 'find', 'fire', 'first', 'fish', 'five', 'food', 'for',
      'form', 'found', 'four', 'friend', 'from', 'front', 'full', 'fun', 'game', 'gave',
      'get', 'girl', 'give', 'go', 'going', 'good', 'got', 'great', 'green', 'ground',
      'group', 'grow', 'had', 'half', 'hand', 'hard', 'has', 'have', 'he', 'head',
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Text Recognition App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildImageSection(),
            const SizedBox(height: 20),
            _buildSelectedWordLists(),
            const SizedBox(height: 20),
            _buildScannedTextSection(),
            const SizedBox(height: 20),
            _buildWordCountSection(),
            const SizedBox(height: 20),
            _buildButtonsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return _imageFile == null
        ? Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: const Text(
              'Select an image to analyze.',
              style: TextStyle(fontSize: 20),
            ),
          )
        : Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(_imageFile!),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Legend:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    _buildLegendItem('Sight Words (List 1)', Colors.blue),
                    _buildLegendItem('Sight Words (List 2)', Colors.red),
                    _buildLegendItem('Common in Both Lists', Colors.green),
                  ],
                ),
              ),
            ],
          );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget  _buildSelectedWordLists() {
    return Column(
      children: _availableWordLists.keys.map((String list) {
        return CheckboxListTile(
          title: Text(list),
          value: _selectedWordLists.contains(list),
          onChanged: (bool? value) {
            setState(() {
              if (value != null && value) {
                _selectedWordLists.add(list);
              } else {
                _selectedWordLists.remove(list);
              }
              _sightWordCount = 0; // Reset sight word count
              _nonSightWordCount = 0; // Reset non-sight word count
            });
            _processImage();
          },
        );
      }).toList(),
    );
  }

  _buildScannedTextSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        children: _scannedText.isEmpty ? [] : _buildTextSpans(_scannedText),
      ),
      textAlign: TextAlign.center,
    );
  }

  _buildWordCountSection() {
    return Row(
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
    );
  }

  _buildButtonsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.gallery),
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
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.camera),
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
          child: const Text('Capture Image', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  List<TextSpan> _buildTextSpans(String text) {
    List<TextSpan> spans = [];
    List<String> words = text.split(RegExp(r'\s+'));
    List<String> selectedWords = [];

    // Gather words from selected lists
    for (String list in _selectedWordLists) {
      selectedWords.addAll(_availableWordLists[list] ?? []);
    }

    // If no lists are selected, apply default styling to all words
    if (selectedWords.isEmpty) {
      for (String word in words) {
        spans.add(
          TextSpan(
            text: '$word ',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      }
    } else {
      for (String word in words) {
        bool isSelectedWord = selectedWords.contains(word.toLowerCase());
        if (isSelectedWord) {
          spans.add(
            TextSpan(
              text: '$word ',
              style: TextStyle(
                fontSize: 16,
                color: _getHighlightColor(word),
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: '$word ',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          );
        }
      }
    }

    return spans;
  }

  Color _getHighlightColor(String word) {
    if (_selectedWordLists.length == 1) {
      String selectedList = _selectedWordLists.first;
      if (_availableWordLists[selectedList]?.contains(word.toLowerCase()) ?? false) {
        return selectedList == '100 Sight Words (List 1)' ? Colors.blue : Colors.red;
      }
    } else if (_selectedWordLists.length == 2) {
      bool isList1Word = _availableWordLists['100 Sight Words (List 1)']?.contains(word.toLowerCase()) ?? false;
      bool isList2Word = _availableWordLists['100 Sight Words (List 2)']?.contains(word.toLowerCase()) ?? false;
      if (isList1Word && isList2Word) {
        return Colors.green; // Highlight overlapping words in both lists as green
      } else if (isList1Word) {
        return Colors.blue;
      } else if (isList2Word) {
        return Colors.red;
      }
    }
    return Colors.black; // Default color for non-selected words
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
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
    if (_selectedWordLists.isEmpty) return; // Exit early if no word list is selected

    try {
      final inputImage = InputImage.fromFilePath(_imageFile!.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String extractedText = recognizedText.text.toLowerCase();

      // Split the extracted text into individual words
      List<String> words = extractedText.split(RegExp(r'\s+'));
      List<String> selectedWordLists = [];
      for (String list in _selectedWordLists) {
        selectedWordLists.addAll(_availableWordLists[list] ?? []);
      }

      int sightWordCount = 0;

      // Compare each word with the selected word lists to determine if it's a sight word
      for (String word in words) {
        if (selectedWordLists.contains(word)) {
          sightWordCount++;
        }
      }

      setState(() {
        _scannedText = recognizedText.text;
        _sightWordCount = sightWordCount;
        _nonSightWordCount = words.length - sightWordCount;
      });
    } catch (e) {
      // Handle error
    }
  }
}