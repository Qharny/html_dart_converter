import 'package:html_dart_convertor/html_dart_convertor.dart';
import 'package:test/test.dart';

void main() {
  late HtmlToMarkdownConverter converter;

  setUp(() {
    converter = HtmlToMarkdownConverter();
  });

  test('converts headings', () {
    expect(converter.convert('<h1>Hello World</h1>'), equals('# Hello World\n\n'));
    expect(converter.convert('<h3>Subtitle</h3>'), equals('### Subtitle\n\n'));
  });

  test('converts paragraph', () {
    expect(converter.convert('<p>This is a paragraph.</p>'), equals('This is a paragraph.\n\n'));
  });

  test('converts links', () {
    expect(
      converter.convert('<a href="https://dart.dev">Dart</a>'),
      equals('[Dart](https://dart.dev)')
    );
    expect(
      converter.convert('<a href="https://dart.dev" title="Dart language">Dart</a>'),
      equals('[Dart](https://dart.dev "Dart language")')
    );
  });

  test('converts text styles', () {
    expect(converter.convert('<strong>Bold</strong>'), equals('**Bold**'));
    expect(converter.convert('<em>Italic</em>'), equals('*Italic*'));
    expect(converter.convert('<code>Inline code</code>'), equals('`Inline code`'));
  });

  test('converts lists', () {
    expect(
      converter.convert('<ul><li>Item 1</li><li>Item 2</li></ul>'),
      equals('- Item 1\n- Item 2\n\n')
    );
    expect(
      converter.convert('<ol><li>First</li><li>Second</li></ol>'),
      equals('1. First\n2. Second\n\n')
    );
  });

  test('converts images', () {
    expect(
      converter.convert('<img src="image.jpg" alt="An image">'),
      equals('![An image](image.jpg)')
    );
    expect(
      converter.convert('<img src="image.jpg" alt="An image" title="Image title">'),
      equals('![An image](image.jpg "Image title")')
    );
  });

  test('converts code blocks', () {
    expect(
      converter.convert('<pre><code>var x = 5;</code></pre>'),
      equals('```\nvar x = 5;\n```\n\n')
    );
  });

  test('converts blockquotes', () {
    expect(
      converter.convert('<blockquote><p>Quote</p></blockquote>'),
      equals('> Quote\n\n')
    );
  });

  test('converts horizontal rules', () {
    expect(converter.convert('<hr>'), equals('---\n\n'));
  });

  test('converts tables', () {
    final html = '''
      <table>
        <thead>
          <tr><th>Header 1</th><th>Header 2</th></tr>
        </thead>
        <tbody>
          <tr><td>Cell 1</td><td>Cell 2</td></tr>
          <tr><td>Cell 3</td><td>Cell 4</td></tr>
        </tbody>
      </table>
    ''';
    final expected = '''
| Header 1 | Header 2 |
| --- | --- |
| Cell 1 | Cell 2 |
| Cell 3 | Cell 4 |

''';
    expect(converter.convert(html), equals(expected));
  });

  test('escapes Markdown characters', () {
    expect(
      converter.convert('<p>This is a paragraph with *asterisks* and [brackets].</p>'),
      equals('This is a paragraph with \\*asterisks\\* and \\[brackets\\].\n\n')
    );
  });
}