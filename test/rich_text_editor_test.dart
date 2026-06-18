import 'package:flint_ui/flint_ui_core.dart';
import 'package:test/test.dart';

void main() {
  group('RichTextEditor controls', () {
    test('RichTextEditor wires label, wrapper, editor and attributes in build', () {
      final editor = RichTextEditor(
        label: 'Message',
        name: 'message',
        placeholder: 'Write your message here',
        required: true,
        helpText: 'Supports rich formatting.',
        error: 'Message is invalid',
        height: '280px',
      );

      final view = editor.build() as FlintElement;
      expect(view.tag, 'div');
      
      final label = view.children[0] as FlintElement;
      final container = view.children[1] as FlintElement;
      final helpText = view.children[2] as FlintElement;
      final errorText = view.children[3] as FlintElement;

      expect(label.tag, 'label');
      expect(label.props['for'], 'flint-editor-message');

      expect(container.tag, 'div');
      expect(container.props['className'], contains('flint-rich-text-editor-container'));

      // Check toolbar
      final toolbar = container.children[0] as FlintElement;
      expect(toolbar.tag, 'div');
      expect(toolbar.props['className'], 'flint-rich-text-editor-toolbar');
      expect(toolbar.children, isNotEmpty);

      // Check editor body
      final body = container.children[1] as FlintElement;
      expect(body.tag, 'div');
      expect(body.props['id'], 'flint-editor-message-content');
      expect(body.props['contenteditable'], 'true');
      expect(body.props['placeholder'], 'Write your message here');
      
      final styleMap = body.props['style'] as Map<String, Object?>;
      expect(styleMap['height'], '280px');

      expect(helpText.tag, 'p');
      expect(helpText.props['id'], 'flint-editor-message-help');

      expect(errorText.tag, 'p');
      expect(errorText.props['id'], 'flint-editor-message-error');
    });

    test('TextEditingController and onUploadImage reference in RichTextEditor', () {
      final controller = TextEditingController(text: '<p>Initial text</p>');
      
      Future<String> mockUpload(dynamic file) async => 'https://mock.cdn/image.png';

      final editor = RichTextEditor(
        name: 'content',
        controller: controller,
        onUploadImage: mockUpload,
      );

      expect(editor.controller, controller);
      expect(editor.onUploadImage, mockUpload);
      expect(editor.placeholder, 'Write something...');

      final view = editor.build() as FlintElement;
      final container = view.children[1] as FlintElement;
      final body = container.children[1] as FlintElement;

      expect(body.props['id'], 'flint-editor-content-content');
      expect(body.props['contenteditable'], 'true');
    });

    test('onChanged callback triggers on build/update if configured', () {
      var triggered = false;
      String? triggeredHtml;
      
      final editor = RichTextEditor(
        name: 'content',
        initialHtml: '<p>Initial</p>',
        onChanged: (html) {
          triggered = true;
          triggeredHtml = html;
        },
      );
      
      expect(editor.onChanged, isNotNull);
      
      editor.onChanged!('<p>Updated</p>');
      expect(triggered, isTrue);
      expect(triggeredHtml, '<p>Updated</p>');
    });
  });
}
