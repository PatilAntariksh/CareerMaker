import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ResumeParserService {
  static Future<Map<String, dynamic>> parseResume(html.File file) async {
    final completer = Completer<Map<String, dynamic>>();
    final reader = html.FileReader();

    reader.readAsArrayBuffer(file);

    reader.onLoadEnd.listen((event) async {
      try {
        final Uint8List bytes = reader.result as Uint8List;

        // Safely read PDF from bytes
        final PdfDocument document = PdfDocument(inputBytes: bytes);
        final String text = PdfTextExtractor(document).extractText();
        document.dispose();

        // Extract fields
        final skills = _extractSkills(text);
        final experience = _extractExperience(text);

        completer.complete({
          'skills': skills,
          'experience': experience,
        });
      } catch (e, stack) {
        print("PDF PARSE ERROR: $e\n$stack");
        completer.completeError('Failed to parse resume.');
      }
    });

    return completer.future;
  }

  static List<String> _extractSkills(String text) {
    final knownSkills = [
      'python', 'java', 'flutter', 'sql', 'html', 'css', 'dart',
      'javascript', 'node.js', 'react', 'firebase', 'git',
      'data analysis', 'machine learning'
    ];
    final lower = text.toLowerCase();
    return knownSkills.where((skill) => lower.contains(skill)).toList();
  }

  static String _extractExperience(String text) {
    final match = RegExp(r'(\d+)\s+(years?|yrs?)\s+of\s+experience',
            caseSensitive: false)
        .firstMatch(text);
    return match != null ? match.group(0)! : 'Experience not found';
  }
}
