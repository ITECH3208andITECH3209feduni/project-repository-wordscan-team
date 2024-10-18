import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:share/share.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book-Scanner: A Sight Word and Vocabulary Identification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
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
  final List<String> _selectedWordLists = [];

  final Map<String, List<String>> _availableWordLists = {
    'Words 1-100': [
      'the', 'and', 'a', 'to', 'i', 'you', 'in', 'of', 'it', 'he', 'is', 'was',
      'for', 'on', 'that', 'with', 'but', 'his', 'all', 'they', 'my', 'so', 'be',
      'she', 'up', 'at', 'are', 'one', 'said', 'what', 'this', 'when', 'we', 'me',
      'have', 'as', 'do', 'like', 'out', 'can', 'her', 'not', 'then', 'your', 'no',
      'there', 'day', 'just', 'it\'s', 'see', 'little', 'time', 'from', 'had', 'now',
      'will', 'i\'m', 'go', 'were', 'too', 'them', 'him', 'some', 'big', 'get', 'if',
      'good', 'don\'t', 'down', 'by', 'how', 'know', 'an', 'oh', 'more', 'their', 'could',
      'about', 'back', 'who', 'or', 'make', 'into', 'look', 'very', 'would', 'right',
      'here', 'love', 'way', 'night', 'did', 'new', 'come', 'our', 'two', 'want', 'made',
      'over', 'around'
    ],
    'Words 101-200': [
      'even', 'away', 'help', 'has', 'home', 'that\'s', 'off', 'got', 'us', 'where',
      'think', 'first', 'through', 'went', 'friends', 'things', 'play', 'take', 'never',
      'other', 'didn\'t', 'after', 'well', 'next', 'say', 'something', 'why', 'because',
      'find', 'before', 'you\'re', 'again', 'fun', 'always', 'long', 'came', 'let\'s',
      'going', 'i\'ll', 'much', 'still', 'thought', 'three', 'people', 'old', 'every',
      'happy', 'really', 'everyone', 'house', 'can\'t', 'looked', 'best', 'eyes', 'head',
      'need', 'only', 'put', 'saw', 'together', 'each', 'great', 'says', 'red', 'give',
      'many', 'found', 'eat', 'asked', 'than', 'while', 'feel', 'school', 'soon', 'called',
      'am', 'mom', 'morning', 'tree', 'last', 'dad', 'bed', 'took', 'friend', 'inside',
      'ever', 'been', 'sure', 'there\'s', 'today', 'does', 'started', 'let', 'green', 'tell',
      'door', 'maybe', 'he\'s', 'small', 'told'
    ],
    'Words 201-300': [
      'please', 'yes', 'wanted', 'world', 'wait', 'thing', 'work', 'hard', 'blue', 'should',
      'until', 'ready', 'water', 'left', 'gave', 'family', 'stop', 'must', 'better', 'knew',
      'thank', 'once', 'room', 'place', 'bear', 'another', 'hear', 'these', 'sleep', 'ran',
      'high', 'try', 'keep', 'most', 'those', 'wasn\'t', 'any', 'sky', 'boy', 'face', 'heard',
      'book', 'snow', 'heart', 'being', 'white', 'sun', 'nice', 'okay', 'cried', 'sometimes',
      'four', 'own', 'couldn\'t', 'name', 'favorite', 'fly', 'dog', 'year', 'might', 'feet',
      'baby', 'outside', 'mother', 'run', 'turn', 'everything', 'also', 'i\'ve', 'looks',
      'makes', 'bad', 'under', 'tried', 'light', 'special', 'stay', 'end', 'story', 'man',
      'began', 'along', 'looking', 'job', 'days', 'ask', 'top', 'you\'ll', 'beautiful', 'life',
      'what\'s', 'which', 'children', 'mr', 'kind', 'full', 'felt', 'read', 'done', 'fast'
    ]
  };

  String? _customWordListName;
  List<String> _customWordList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book-Scanner: A Sight Word and Vocabulary Identification App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildImageSection(),
            const SizedBox(height: 10),
            _buildButtonsSection(),
            const SizedBox(height: 10),
            _buildSelectedWordLists(),
            const SizedBox(height: 10),
            _buildAddCustomWordListButton(),
            const SizedBox(height: 10),
            _buildLegendSection(),
            const SizedBox(height: 10),
            _buildScannedTextSection(),
            const SizedBox(height: 10),
            _buildViewLexicalProfileButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCustomWordListButton() {
    return ElevatedButton(
      onPressed: () => _showCustomWordListDialog(),
      child: Text(_customWordListName == null ? 'Add Custom Word List' : 'Edit Custom Word List'),
    );
  }

  void _showCustomWordListDialog() {
    TextEditingController wordsController = TextEditingController(
      text: _customWordList.isNotEmpty ? _customWordList.join('\n') : '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Custom Word List'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: wordsController,
                  decoration: const InputDecoration(labelText: 'Enter words (one per line)'),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addCustomWordList(wordsController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addCustomWordList(String words) {
    setState(() {
      if (words.isNotEmpty) {
        List<String> wordList = words
            .split('\n')
            .map((word) => word.trim().toLowerCase()) // Normalize to lowercase
            .where((word) => word.isNotEmpty)
            .toSet() // Remove duplicates by converting to a set
            .toList();
        _customWordListName = 'Custom Wordlist';
        _customWordList = wordList;
        _availableWordLists[_customWordListName!] = wordList;
      } else {
        _customWordList = [];
        if (_customWordListName != null) {
          _availableWordLists[_customWordListName!] = [];
        }
      }
    });
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
        : Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: FileImage(_imageFile!),
                fit: BoxFit.contain,
              ),
            ),
          );
  }

  Widget _buildLegendSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Legend:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          _buildLegendItem('Words 1-100', Colors.blue),
          _buildLegendItem('Words 101-200', Colors.red),
          _buildLegendItem('Words 201-300', Colors.purple),
          _buildLegendItem('Custom Wordlist', Colors.orange),
          _buildLegendItem('Common in Two or More Lists', Colors.green),
        ],
      ),
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

  Widget _buildSelectedWordLists() {
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
              _processImage();
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildScannedTextSection() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        children: _scannedText.isEmpty ? [] : _buildHighlightedText(),
      ),
    );
  }

  List<TextSpan> _buildHighlightedText() {
    final List<TextSpan> spans = [];

    final String text = _scannedText.replaceAll(RegExp(r'\n+'), ' ').replaceAll(RegExp(r'\s+'), ' ');

    final List<String> segments = _splitTextIntoSegments(text);
    final Set<String> uniqueWords = {};
    final Map<String, Color> wordColors = {};
    final Map<String, int> wordListCount = {};
    final Map<String, String> normalizedWordsMap = {};

    for (String list in _selectedWordLists) {
      final wordList = _availableWordLists[list] ?? [];
      for (String word in wordList) {
        String normalizedWord = _normalizeWord(word);
        uniqueWords.add(normalizedWord);
        normalizedWordsMap[normalizedWord] = word;
        wordListCount[normalizedWord] = (wordListCount[normalizedWord] ?? 0) + 1;
        wordColors[normalizedWord] = _getColorForList(list);
      }
    }

    for (String word in wordListCount.keys) {
      if (wordListCount[word]! > 1) {
        wordColors[word] = Colors.green;
      }
    }

    for (final segment in segments) {
      if (_isWord(segment)) {
        String normalizedSegment = _normalizeWord(segment);
        Color color = Colors.black;
        if (uniqueWords.contains(normalizedSegment)) {
          color = wordColors[normalizedSegment] ?? Colors.black;
        }
        spans.add(
          TextSpan(
            text: segment,
            style: TextStyle(color: color),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: segment,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }
    }

    return spans;
  }

  List<String> _splitTextIntoSegments(String text) {
    final RegExp regex = RegExp(r'(\w+|[^\w\s]+|\s)');
    return regex.allMatches(text).map((match) => match.group(0)!).toList();
  }

  bool _isWord(String segment) {
    return RegExp(r'^\w+$').hasMatch(segment);
  }

  String _normalizeWord(String word) {
    return word.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();
  }

  Color _getColorForList(String list) {
    switch (list) {
      case 'Words 1-100':
        return Colors.blue;
      case 'Words 101-200':
        return Colors.red;
      case 'Words 201-300':
        return Colors.purple;
      case 'Custom Wordlist':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  Widget _buildButtonsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          child: const Text('Pick Image'),
        ),
        ElevatedButton(
          onPressed: () => _pickImage(ImageSource.camera),
          child: const Text('Capture Image'),
        ),
      ],
    );
  }

  Widget _buildViewLexicalProfileButton() {
    return ElevatedButton(
      onPressed: () {
        if (_scannedText.isNotEmpty && _selectedWordLists.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StatisticsPage(
                scannedText: _scannedText,
                selectedWordLists: _selectedWordLists,
                availableWordLists: _availableWordLists,
              ),
            ),
          );
        } else if (_selectedWordLists.isEmpty) {
          _showSelectListDialog();
        }
      },
      child: const Text('View Statistics of Scanned Text'),
    );
  }

  void _showSelectListDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Lists Selected'),
          content: const Text('Please select at least one word list to view the statistics.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _processImage();
      });
    }
  }

  Future<void> _processImage() async {
    if (_selectedWordLists.isEmpty || _imageFile == null) return;

    try {
      final inputImage = InputImage.fromFilePath(_imageFile!.path);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      String extractedText = recognizedText.text;

      setState(() {
        _scannedText = extractedText;
      });
    } catch (e) {
      // Handle error
    }
  }
}

class StatisticsPage extends StatelessWidget {
  final String scannedText;
  final List<String> selectedWordLists;
  final Map<String, List<String>> availableWordLists;

  final ScrollController _cpbScrollController = ScrollController();
  final ScrollController _customScrollController = ScrollController();

  // Define these variables as instance variables so they are accessible throughout the class
  final Map<String, List<String>> cpbWords = {};
  final Map<String, int> cpbListCounts = {};
  final List<String> customWords = [];

  StatisticsPage({
    super.key,
    required this.scannedText,
    required this.selectedWordLists,
    required this.availableWordLists,
  }) {
    _initializeWordStatistics();
  }

  

  List<String> _getNormalizedWords(String text) {
  return text
      .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
      .toLowerCase() // Convert to lowercase
      .split(RegExp(r'\s+')) // Split into words
      .where((word) => word.isNotEmpty) // Remove empty words
      .toList();
}


  // Initialize word statistics
  void _initializeWordStatistics() {
  // Normalize the scanned text and split it into words
  final words = _getNormalizedWords(scannedText);

  for (String list in selectedWordLists) {
    if (list == 'Custom Wordlist') {
      cpbListCounts[list] = 0;
    } else {
      cpbListCounts[list] = 0;
      cpbWords[list] = [];
    }
  }

  for (String list in selectedWordLists) {
    final wordList = availableWordLists[list]?.map((word) => _normalizeWord(word)).toList() ?? [];

    for (String word in words) {
      if (wordList.contains(word)) {
        cpbListCounts[list] = (cpbListCounts[list] ?? 0) + 1;
        if (list == 'Custom Wordlist') {
          if (!customWords.contains(word)) {
            customWords.add(word);
          }
        } else {
          if (!cpbWords[list]!.contains(word)) {
            cpbWords[list]!.add(word);
          }
        }
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {

    final List<String> words = _getNormalizedWords(scannedText);

    final List<String> fixedWordListOrder = [
      'Words 1-100',
      'Words 101-200',
      'Words 201-300',
    ];

    bool isOnlyCustomListSelected = selectedWordLists.length == 1 && selectedWordLists.contains('Custom Wordlist');

    List<String> sortedWordLists = selectedWordLists
        .where((list) => fixedWordListOrder.contains(list))
        .toList()
      ..sort((a, b) => fixedWordListOrder.indexOf(a).compareTo(fixedWordListOrder.indexOf(b)));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics of Scanned Text',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isOnlyCustomListSelected) ...[
              const Text(
                'CPB Sight Words Statistics',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Scrollbar(
                controller: _cpbScrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _cpbScrollController,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
  columnSpacing: 16,
  dataRowMaxHeight: 100,
  columns: const [
    DataColumn(label: Text('Word List')),
    DataColumn(label: Text('Coverage of Text (%)')),
    DataColumn(label: Text('Cumulative Text Coverage (%)')),
    DataColumn(label: Text('Sight Words (Frequency Ranks)')),
    DataColumn(label: Text('Sight Words (Frequency Count)')),
  ],
  rows: [
    ...sortedWordLists.where((list) => list != 'Custom Wordlist').map((list) {
      int index = sortedWordLists.indexOf(list);

      final uniqueWordList = cpbWords[list]!;

      final double coveragePercentages = uniqueWordList.isNotEmpty
                          ? uniqueWordList.map((word) {
                              final int wordLength = word.length;
                              final int wordCount = words.where((w) => w == word).length;
                              return (wordCount * wordLength / scannedText.length) * 100;
                            }).reduce((a, b) => a + b)
                          : 0.0;

      final double cumulativeCoverage = sortedWordLists
                          .sublist(0, index + 1)
                          .where((l) => l != 'Custom Wordlist')
                          .map((l) {
                            final List<String> cumulativeWords = cpbWords[l]!;
                            final double cumulative = cumulativeWords.isNotEmpty
                                ? cumulativeWords.map((word) {
                                    final int wordLength = word.length;
                                    final int wordCount = words.where((w) => w == word).length;
                                    return (wordCount * wordLength / scannedText.length) * 100;
                                  }).reduce((a, b) => a + b)
                                : 0.0;
                            return cumulative;
                          }).fold(0.0, (a, b) => a + b);

      final sortedWordsWithRanks = uniqueWordList
          .map((word) {
            int rank = availableWordLists[list]!.indexOf(word) + 1;
            int count = scannedText.split(' ').where((w) => w == word).length;
            return MapEntry(word, {'rank': rank, 'count': count});
          })
          .toList()
        ..sort((a, b) => (a.value['rank'] ?? 0).compareTo(b.value['rank'] ?? 0));

      final cpbWordsText = sortedWordsWithRanks.isNotEmpty
          ? sortedWordsWithRanks.map((entry) => '${entry.key} (${entry.value['rank']!})').join('\n')
          : '-';

      final frequencyCounts = sortedWordsWithRanks.isNotEmpty
    ? sortedWordsWithRanks.map((entry) {
        int count = words.where((w) => w == entry.key).length;
        return '${entry.key}: $count';
      }).join('\n')
    : '-';


      return DataRow(cells: [
        DataCell(Text(list)),
        DataCell(Text('${coveragePercentages.toStringAsFixed(2)}%')),
        DataCell(Text('${cumulativeCoverage.toStringAsFixed(2)}%')),
        DataCell(
          SizedBox(
            width: 200, 
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(cpbWordsText),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: 200, 
            height: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(frequencyCounts),
            ),
          ),
        ),
      ]);
    }),
  ],
)



                ),
              ),
              const SizedBox(height: 20),
            ],

            if (selectedWordLists.contains('Custom Wordlist') && customWords.isNotEmpty) ...[
  const Text(
    'Custom Word List Statistics:',
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
  const SizedBox(height: 20),
  Scrollbar(
    controller: _customScrollController,
    thumbVisibility: true,
    child: SingleChildScrollView(
      controller: _customScrollController,
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        dataRowMaxHeight: 100,
        columns: const [
          DataColumn(label: Text('Word List')),
          DataColumn(label: Text('Coverage of Text (%)')),
          DataColumn(label: Text('Custom Wordlist Words (Frequency Count)')),
        ],
        rows: [
                      DataRow(cells: [
            const DataCell(Text('Custom Wordlist')),
            
            
            DataCell(Text(
              customWords.isNotEmpty
                  ? '${customWords.map((word) {
                      final int wordLength = word.length;
                      final int wordCount = words.where((w) => w == word).length;
                      return (wordCount * wordLength / scannedText.length) * 100;
                    }).reduce((a, b) => a + b).toStringAsFixed(2)}%'
                  : '0.00%',
            )),
                         DataCell(
              SizedBox(
                width: 200,
                height: 100,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: customWords.isNotEmpty
                        ? customWords.map((word) {
                            int count = words.where((w) => w == word).length;
                            return Text('$word: $count');
                          }).toList()
                        : [const Text('No words found')],
      ),
    ),
  ),
),


                      ]),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back to Main Page'),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: _exportToCsv,
                child: const Text('Export as CSV'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'The CPB Sight Words are freely available here:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                text:
                    'Green, C., Keogh, K., & Prout, J. (2024). The CPB Sight Words: A New Research‐Based High‐Frequency Wordlist for Early Reading Instruction. The Reading Teacher. ',
                style: const TextStyle(fontSize: 12, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'https://doi.org/10.1002/trtr.2309',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(Uri.parse('https://doi.org/10.1002/trtr.2309'));
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _normalizeWord(String word) {
    return word.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();
  }

Future<void> _exportToCsv() async {
  
  List<List<String>> csvData = [
    ['CPB Sight Words Statistics'],
    ['Word List', 'Coverage of Text (%)', 'Cumulative Text Coverage (%)', 'Sight Words (Frequency Ranks)', 'Sight Words (Frequency Count)'],
  ];

  
  final words = _getNormalizedWords(scannedText);

  
  for (String list in selectedWordLists) {
    if (list != 'Custom Wordlist') {
      final uniqueWordList = cpbWords[list]!;

      
      final coveragePercentages = uniqueWordList.isNotEmpty
          ? uniqueWordList.map((word) {
              final wordLength = word.length;
              final wordCount = words.where((w) => w == word).length;
              return (wordCount * wordLength / scannedText.length) * 100;
            }).reduce((a, b) => a + b)
          : 0.0;

      
      final cumulativeCoverage = selectedWordLists
          .where((l) => l != 'Custom Wordlist')
          .takeWhile((l) => l != list)
          .map((l) {
            final uniqueWords = cpbWords[l]!;
            return uniqueWords.isNotEmpty
                ? uniqueWords.map((word) {
                    final wordLength = word.length;
                    final wordCount = words.where((w) => w == word).length;
                    return (wordCount * wordLength / scannedText.length) * 100;
                  }).reduce((a, b) => a + b)
                : 0.0;
          }).fold(0.0, (a, b) => a + b) + coveragePercentages;

      final sortedWordsWithRanks = uniqueWordList
          .map((word) {
            int rank = availableWordLists[list]!.indexOf(word) + 1;
            int count = words.where((w) => w == word).length;
            return MapEntry(word, {'rank': rank, 'count': count});
          })
          .toList()
        ..sort((a, b) => (a.value['rank'] ?? 0).compareTo(b.value['rank'] ?? 0));

      final cpbWordsText = sortedWordsWithRanks.isNotEmpty
          ? sortedWordsWithRanks.map((entry) => '${entry.key} (${entry.value['rank']!})').join(', ')
          : '-';

      final frequencyCounts = sortedWordsWithRanks.isNotEmpty
          ? sortedWordsWithRanks.map((entry) => '${entry.key}: ${entry.value['count'] ?? 0}').join(', ')
          : '-';

      csvData.add([list, coveragePercentages.toStringAsFixed(2), cumulativeCoverage.toStringAsFixed(2), cpbWordsText, frequencyCounts]);
    }
  }

  csvData.add([]);
  csvData.add(['Custom Word List Statistics']);
  csvData.add(['Word List', 'Coverage of Text (%)', 'Custom Wordlist Words (Frequency Count)']);

  if (selectedWordLists.contains('Custom Wordlist') && customWords.isNotEmpty) {

    final double customCoverage = customWords.map((word) {
      final int wordLength = word.length;
      final int wordCount = words.where((w) => w == word).length;
      return (wordCount * wordLength / scannedText.length) * 100;
    }).reduce((a, b) => a + b);

    String customWordListText = customWords
        .map((word) {
          int count = words.where((w) => w == word).length;
          return '$word: $count';
        })
        .join(', ');

    csvData.add([
      'Custom Wordlist',
      customCoverage.toStringAsFixed(2),
      customWordListText,
    ]);
  } else {
    csvData.add(['Custom Wordlist', '0.00%', 'No words found']);
  }


  String csv = const ListToCsvConverter().convert(csvData);


  final directory = await getTemporaryDirectory();
  final path = '${directory.path}/statistics.csv';
  final file = File(path);


  await file.writeAsString(csv);


  await Share.shareFiles([path], text: 'Statistics CSV File');
}




}