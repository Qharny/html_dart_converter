import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart';

class HtmlToMarkdownConverter {
  String convert(String html) {
    var document = htmlParser.parse(html);
    return _processNode(document.body!).trim();
  }

  String _processNode(Node node) {
    if (node is Text) {
      return _escapeMarkdown(node.text.trim());
    } else if (node is Element) {
      var markdown = '';
      
      switch (node.localName) {
        case 'h1':
        case 'h2':
        case 'h3':
        case 'h4':
        case 'h5':
        case 'h6':
          var level = int.parse(node.localName![1]);
          markdown = '${'#' * level} ${_processChildren(node)}\n\n';
          break;
        case 'p':
          markdown = '${_processChildren(node)}\n\n';
          break;
        case 'a':
          var href = node.attributes['href'] ?? '';
          var title = node.attributes['title'] ?? '';
          var linkText = _processChildren(node);
          markdown = title.isEmpty
              ? '[$linkText]($href)'
              : '[$linkText]($href "$title")';
          break;
        case 'strong':
        case 'b':
          markdown = '**${_processChildren(node)}**';
          break;
        case 'em':
        case 'i':
          markdown = '*${_processChildren(node)}*';
          break;
        case 'code':
          markdown = '`${_processChildren(node)}`';
          break;
        case 'pre':
          var code = node.children.firstWhere((child) => child.localName == 'code', orElse: () => node);
          markdown = '```\n${_processChildren(code)}\n```\n\n';
          break;
        case 'ul':
          for (var child in node.children.where((c) => c.localName == 'li')) {
            markdown += '- ${_processChildren(child)}\n';
          }
          markdown += '\n';
          break;
        case 'ol':
          var index = 1;
          for (var child in node.children.where((c) => c.localName == 'li')) {
            markdown += '$index. ${_processChildren(child)}\n';
            index++;
          }
          markdown += '\n';
          break;
        case 'img':
          var src = node.attributes['src'] ?? '';
          var alt = node.attributes['alt'] ?? '';
          var title = node.attributes['title'] ?? '';
          markdown = title.isEmpty
              ? '![$alt]($src)'
              : '![$alt]($src "$title")';
          break;
        case 'hr':
          markdown = '---\n\n';
          break;
        case 'blockquote':
          markdown = node.children
              .map((child) => '> ${_processNode(child)}')
              .join('\n>\n');
          markdown += '\n\n';
          break;
        case 'table':
          markdown = _processTable(node);
          break;
        default:
          markdown = _processChildren(node);
      }
      
      return markdown;
    }
    
    return '';
  }

  String _processChildren(Element element) {
    return element.nodes.map(_processNode).join().trim();
  }

  String _escapeMarkdown(String text) {
    return text.replaceAllMapped(RegExp(r'([\\`*_{}[\]()#+\-.!])'), (match) => '\\${match.group(1)}');
  }

  String _processTable(Element table) {
    var markdown = '';
    var headers = table.querySelector('thead')?.querySelectorAll('th') ?? [];
    var rows = table.querySelectorAll('tbody tr');

    if (headers.isNotEmpty) {
      markdown += '| ${headers.map((h) => _processChildren(h)).join(' | ')} |\n';
      markdown += '| ${headers.map((_) => '---').join(' | ')} |\n';
    }

    for (var row in rows) {
      var cells = row.querySelectorAll('td');
      markdown += '| ${cells.map((c) => _processChildren(c)).join(' | ')} |\n';
    }

    return '$markdown\n';
  }
}