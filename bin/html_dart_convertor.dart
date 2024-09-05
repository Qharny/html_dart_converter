import 'dart:io';
import 'package:html_dart_convertor/html_dart_convertor.dart';

void main(List<String> arguments) {
  final converter = HtmlToMarkdownConverter();

  if (arguments.isEmpty) {
    // Interactive mode
    print('Enter HTML (press Ctrl+D when finished):');
    final html = stdin.readLineSync()!;
    final markdown = converter.convert(html);
    print('\nConverted Markdown:');
    print(markdown);
  } else if (arguments.length == 1) {
    // File input mode
    final file = File(arguments[0]);
    if (!file.existsSync()) {
      print('Error: File not found');
      exit(1);
    }
    final html = file.readAsStringSync();
    final markdown = converter.convert(html);
    print(markdown);
  } else {
    print('Usage: dart bin/main.dart [input_file]');
    print('If no input file is provided, the program will run in interactive mode.');
    exit(1);
  }
}