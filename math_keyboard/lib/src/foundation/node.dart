import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Block representing a node of TeX.
class TeXNode {
  /// Constructs a [TeXNode].
  TeXNode(this.parent);

  /// The parent of the node.
  TeXFunction? parent;

  /// The courser position in this node.
  int courserPosition = 0;

  /// A block can have one or more child blocks.
  final List<TeX> children = [];

  /// Sets the courser to the actual position.
  void setCursor() {
    children.insert(courserPosition, const Cursor());
  }

  /// Removes the courser.
  void removeCursor() {
    children.removeAt(courserPosition);
  }

  /// Returns whether the last child node is the cursor.
  ///
  /// This does *not* traverse the children recursively as that might not be
  /// a guarantee for visually being all the way on the right with the cursor.
  /// Imagine a `\frac` node with a horizontally long string in the nominator:
  /// now, when the cursor is at the end, it is not visually on the right of the
  /// node as the denominator might not even be visible when scrolling to the
  /// right.
  bool cursorAtTheEnd() {
    if (children.isEmpty) return false;
    if (children.last is Cursor) return true;

    return false;
  }

  /// Shift courser to the left.
  NavigationState shiftCursorLeft() {
    if (courserPosition == 0) {
      return NavigationState.end;
    }
    removeCursor();
    courserPosition--;
    if (children[courserPosition] is TeXFunction) {
      return NavigationState.func;
    }
    setCursor();
    return NavigationState.success;
  }

  /// Shift courser to the right.
  NavigationState shiftCursorRight() {
    if (courserPosition == children.length - 1) {
      return NavigationState.end;
    }
    removeCursor();
    courserPosition++;
    if (children[courserPosition - 1] is TeXFunction) {
      return NavigationState.func;
    }
    setCursor();
    return NavigationState.success;
  }

  /// Adds a new node.
  void addTeX(TeX teX) {
    children.insert(courserPosition, teX);
    courserPosition++;
  }

  /// Removes the last node.
  NavigationState remove() {
    if (courserPosition == 0) {
      return NavigationState.end;
    }
    removeCursor();
    courserPosition--;
    if (children[courserPosition] is TeXFunction) {
      return NavigationState.func;
    }

    // Special handling for system structures (\begin{cases}...\end{cases})
    // If we're about to delete part of a system, delete the entire system instead
    if (children[courserPosition] is TeXLeaf) {
      final leaf = children[courserPosition] as TeXLeaf;
      final expr = leaf.expression;

      // Check if this leaf contains system markers
      if (expr.contains(r'\begin{cases}') || expr.contains(r'\end{cases}')) {
        // Find and remove all consecutive leaves that are part of the system
        _removeSystemStructure(courserPosition);
        setCursor();
        return NavigationState.success;
      }

      // Check if this leaf contains a LaTeX command that starts with backslash
      // If so, delete the entire command at once to avoid invalid intermediate states
      if (expr.startsWith(r'\')) {
        // This is a LaTeX command - delete it entirely
        children.removeAt(courserPosition);
        setCursor();
        return NavigationState.success;
      }
    }

    children.removeAt(courserPosition);
    setCursor();
    return NavigationState.success;
  }

  /// Removes an entire system structure when deleting
  void _removeSystemStructure(int startPosition) {
    // Look backwards and forwards to find all parts of the system
    int start = startPosition;
    int end = startPosition;

    // Find the start of the system
    for (int i = startPosition; i >= 0; i--) {
      if (children[i] is TeXLeaf) {
        final expr = (children[i] as TeXLeaf).expression;
        if (expr.contains(r'\begin{cases}')) {
          start = i;
          break;
        }
      }
    }

    // Find the end of the system
    for (int i = startPosition; i < children.length; i++) {
      if (children[i] is TeXLeaf) {
        final expr = (children[i] as TeXLeaf).expression;
        if (expr.contains(r'\end{cases}')) {
          end = i;
          break;
        }
      }
    }

    // Remove all elements from start to end (inclusive)
    if (start <= end) {
      children.removeRange(start, end + 1);
      courserPosition = start;
    }
  }

  /// Builds the TeX representation of this node.
  ///
  /// This includes the representation of the children of the node.
  ///
  /// Returns the TeX expression as a [String].
  String buildTeXString({
    Color? cursorColor,
    bool placeholderWhenEmpty = true,
  }) {
    if (children.isEmpty) {
      return placeholderWhenEmpty ? '\\Box' : '';
    }
    final buffer = StringBuffer();
    for (int i = 0; i < children.length; i++) {
      final current = children[i].buildString(cursorColor: cursorColor);
      buffer.write(current);

      // Add space after TeX commands when followed by letters to prevent
      // concatenation issues like \cdotx
      if (i < children.length - 1) {
        final next = children[i + 1].buildString(cursorColor: cursorColor);
        if (_needsSpaceBetween(current, next)) {
          buffer.write(' ');
        }
      }
    }
    return buffer.toString();
  }

  /// Checks if a space is needed between two TeX strings to prevent
  /// invalid concatenation like \cdotx or \cdot4 being interpreted as 24
  bool _needsSpaceBetween(String current, String next) {
    // If current ends with a TeX command and next starts with a letter or number
    if (current.contains(r'\') &&
        next.isNotEmpty &&
        RegExp(r'^[a-zA-Z0-9]').hasMatch(next)) {
      // Check if current ends with a TeX command
      final commandMatch = RegExp(r'\\[a-zA-Z]+$').firstMatch(current);
      if (commandMatch != null) {
        return true;
      }
    }
    return false;
  }
}

/// Class holding a TeX function.
class TeXFunction extends TeX {
  /// Constructs a [TeXFunction].
  ///
  /// [argNodes] can be passed directly if the nodes are already known. In that
  /// case, the [TeXNode.parent] is set in the constructor body. If [argNodes]
  /// is passed empty (default), empty [TeXNode]s will be inserted for each
  /// arg.
  TeXFunction(String expression, this.parent, this.args,
      [List<TeXNode>? argNodes])
      : assert(args.isNotEmpty, 'A function needs at least one argument.'),
        assert(argNodes == null || argNodes.length == args.length),
        argNodes = argNodes ?? List.empty(growable: true),
        super(expression) {
    if (this.argNodes.isEmpty) {
      for (var i = 0; i < args.length; i++) {
        this.argNodes.add(TeXNode(this));
      }
    } else {
      for (final node in this.argNodes) {
        node.parent = this;
      }
    }
  }

  /// The functions parent node.
  TeXNode parent;

  /// The delimiters of the arguments.
  final List<TeXArg> args;

  /// The arguments to this function.
  final List<TeXNode> argNodes;

  /// Returns the opening character for a function argument.
  String openingChar(TeXArg type) {
    switch (type) {
      case TeXArg.braces:
        return '{';
      case TeXArg.brackets:
        return '[';
      default:
        return '(';
    }
  }

  /// Returns the closing character for a function argument.
  String closingChar(TeXArg type) {
    switch (type) {
      case TeXArg.braces:
        return '}';
      case TeXArg.brackets:
        return ']';
      default:
        return ')';
    }
  }

  @override
  String buildString({Color? cursorColor}) {
    final buffer = StringBuffer(expression);
    for (var i = 0; i < args.length; i++) {
      buffer.write(openingChar(args[i]));
      buffer.write(argNodes[i].buildTeXString(cursorColor: cursorColor));
      buffer.write(closingChar(args[i]));
    }
    return buffer.toString();
  }
}

/// Class holding a single TeX expression.
class TeXLeaf extends TeX {
  /// Constructs a [TeXLeaf].
  const TeXLeaf(String expression) : super(expression);

  @override
  String buildString({Color? cursorColor}) {
    return expression;
  }
}

/// Class holding TeX.
abstract class TeX {
  /// Constructs a [TeX].
  const TeX(this.expression);

  /// The expression of this TeX
  final String expression;

  /// Builds the string representation of this TeX expression.
  String buildString({required Color? cursorColor});
}

/// Class describing the cursor as a TeX expression.
class Cursor extends TeX {
  /// Creates a TeX [Cursor].
  const Cursor() : super('');

  @override
  String buildString({required Color? cursorColor}) {
    if (cursorColor == null) {
      throw FlutterError('Cursor.buildString() called without a cursorColor.');
    }
    return '\\textcolor{${cursorColor.toHex()}}{\\cursor}';
  }
}

/// Extension to convert a [Color] to a hex string.
extension HexColor on Color {
  /// Converts a [Color] to a hex string to be used in TeX.
  String toHex() => '#'
      '${_floatToInt8(r).toRadixString(16).padLeft(2, '0')}'
      '${_floatToInt8(g).toRadixString(16).padLeft(2, '0')}'
      '${_floatToInt8(b).toRadixString(16).padLeft(2, '0')}';

  int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}

/// The state of a node when trying to navigate back- or forward.
enum NavigationState {
  /// The upcoming tex expression in navigation direction is a function.
  func,

  /// The current courser position is already at the end.
  end,

  /// Navigating was successful.
  success,
}

/// How the argument is marked.
enum TeXArg {
  /// { }
  ///
  /// In most of the cases, braces will be used. (E.g arguments of fractions).
  braces,

  /// [ ]
  ///
  /// Brackets are only used for the nth root at the moment.
  brackets,

  /// ()
  ///
  /// Parentheses are used for base n logarithm right now, but could be used
  /// for functions like sin, cos, tan, etc. as well, so the user doesn't have
  /// to close the parentheses manually.
  parentheses,
}
