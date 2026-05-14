import 'package:flint_ui/flint_ui_core.dart';
import 'package:test/test.dart';

void main() {
  group('overlay components', () {
    test('Modal and Drawer expose dialog semantics and hidden state', () {
      final modal = Modal(open: false, title: 'Edit user', child: 'Body');
      expect(modal.props['role'], 'dialog');
      expect(modal.props['hidden'], true);
      expect(modal.props['aria-modal'], 'true');

      final drawer = Drawer(open: true, title: 'Details', side: 'left');
      expect(drawer.tag, 'aside');
      expect(drawer.props['role'], 'dialog');
      expect(drawer.props.containsKey('hidden'), false);
      expect(drawer.props['style'], containsPair('left', 0));
    });

    test('Tooltip and Popover render trigger plus overlay content', () {
      final tooltip = Tooltip(
        content: 'More info',
        child: Button(child: 'Info'),
      );
      expect(tooltip.children.first, isA<Button>());
      final tip = tooltip.children.last as FlintElement;
      expect(tip.props['role'], 'tooltip');

      final popover = Popover(
        trigger: Button(child: 'Open'),
        open: false,
        child: Text('Filters'),
      );
      final panel = popover.children.last as FlintElement;
      expect(panel.props['role'], 'dialog');
      expect(panel.props['hidden'], true);
    });

    test('Toast and Skeleton render feedback surfaces', () {
      final toast = Toast(title: 'Saved', message: 'Settings updated');
      expect(toast.props['role'], 'status');
      expect(toast.children.first, isA<FlintElement>());

      final skeleton = Skeleton(lines: 3, width: 120);
      expect(skeleton.children, hasLength(3));
      final line = skeleton.children.first as FlintElement;
      expect(line.props['aria-hidden'], 'true');
      expect(line.props['style'], containsPair('width', '120px'));
    });

    test('ConfirmAction wraps confirmation modal and actions', () {
      final confirm = ConfirmAction(
        open: true,
        title: 'Delete user',
        message: 'This cannot be undone.',
        danger: true,
        onConfirm: (_) {},
        onCancel: (_) {},
      );

      expect(confirm.children.single, isA<Modal>());
      final modal = confirm.children.single as Modal;
      final section = modal.children.single as FlintElement;
      final footer = section.children.last as FlintElement;
      expect(footer.children.single, isA<ButtonGroup>());
    });
  });
}
