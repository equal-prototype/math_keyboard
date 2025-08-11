import 'package:flutter/services.dart';
import 'package:math_keyboard/src/foundation/node.dart';

/// Enumeration for different subject configurations.
enum MathSubject {
  /// Algebra basics
  algebra,

  /// Geometry
  geometry,

  /// Trigonometry
  trigonometry,

  /// Calculus
  calculus,

  /// Statistics
  statistics,

  /// General mathematics
  general,
}

/// Class representing a button configuration.
abstract class KeyboardButtonConfig {
  /// Constructs a [KeyboardButtonConfig].
  const KeyboardButtonConfig({
    this.flex,
    this.keyboardCharacters = const [],
  });

  /// Optional flex.
  final int? flex;

  /// The list of [KeyEvent.character] that should trigger this keyboard
  /// button on a physical keyboard.
  ///
  /// Note that the case of the characters is ignored.
  ///
  /// Special keyboard keys like backspace and arrow keys are specially handled
  /// and do *not* require this to be set.
  ///
  /// Must not be `null` but can be empty.
  final List<String> keyboardCharacters;
}

/// Class representing a button configuration for a [FunctionButton].
class BasicKeyboardButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [KeyboardButtonConfig].
  const BasicKeyboardButtonConfig({
    required this.label,
    required this.value,
    this.args,
    this.asTex = false,
    this.highlighted = false,
    this.longPressOptions,
    this.svgIcon,
    List<String> keyboardCharacters = const [],
    int? flex,
  }) : super(
          flex: flex,
          keyboardCharacters: keyboardCharacters,
        );

  /// The label of the button.
  final String label;

  /// The value in tex.
  final String value;

  /// List defining the arguments for the function behind this button.
  final List<TeXArg>? args;

  /// Whether to display the label as TeX or as plain text.
  final bool asTex;

  /// The highlight level of this button.
  final bool highlighted;

  /// List of options to show on long press.
  final List<String>? longPressOptions;

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  /// When provided, this will be used instead of the label.
  final String? svgIcon;
}

/// Class representing a button configuration of the Delete Button.
class DeleteButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [DeleteButtonConfig].
  DeleteButtonConfig({int? flex, this.svgIcon}) : super(flex: flex);

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  final String? svgIcon;
}

/// Class representing a button configuration of the Previous Button.
class PreviousButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [PreviousButtonConfig].
  PreviousButtonConfig({int? flex, this.svgIcon}) : super(flex: flex);

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  final String? svgIcon;
}

/// Class representing a button configuration of the Next Button.
class NextButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [NextButtonConfig].
  NextButtonConfig({int? flex, this.svgIcon}) : super(flex: flex);

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  final String? svgIcon;
}

/// Class representing a button configuration of the Submit Button.
class SubmitButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [SubmitButtonConfig].
  SubmitButtonConfig({int? flex, this.svgIcon}) : super(flex: flex);

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  final String? svgIcon;
}

/// Class representing a button configuration for subject selection.
class SubjectButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [SubjectButtonConfig].
  const SubjectButtonConfig({
    required this.subject,
    required this.label,
    this.isActive = false,
    int? flex,
  }) : super(flex: flex);

  /// The subject this button represents.
  final MathSubject subject;

  /// The label to display on the button.
  final String label;

  /// Whether this subject is currently active.
  final bool isActive;
}

/// Class representing a button configuration of the Page Toggle Button.
class PageButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [PageButtonConfig].
  const PageButtonConfig({int? flex}) : super(flex: flex);
}

/// List of keyboard button configs for the digits from 0-9.
///
/// List access from 0 to 9 will return the appropriate digit button.
final _digitButtons = [
  for (var i = 0; i < 10; i++)
    BasicKeyboardButtonConfig(
      label: '$i',
      value: '$i',
      keyboardCharacters: ['$i'],
      svgIcon: '$i.svg',
    ),
];

/// Keyboard showing extended functionality.
final functionKeyboard = [
  [
    const BasicKeyboardButtonConfig(
      label: r'\frac{\Box}{\Box}',
      value: r'\frac',
      args: [TeXArg.braces, TeXArg.braces],
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^2',
      value: '^2',
      args: [TeXArg.braces],
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^{\Box}',
      value: '^',
      args: [TeXArg.braces],
      asTex: true,
      keyboardCharacters: [
        '^',
        // This is a workaround for keyboard layout that use ^ as a toggle key.
        // In that case, "Dead" is reported as the character (e.g. for German
        // keyboards).
        'Dead',
      ],
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sin',
      value: r'\sin(',
      asTex: true,
      keyboardCharacters: ['s'],
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sin^{-1}',
      value: r'\sin^{-1}(',
      asTex: true,
    ),
  ],
  [
    const BasicKeyboardButtonConfig(
      label: r'\sqrt{\Box}',
      value: r'\sqrt',
      args: [TeXArg.braces],
      asTex: true,
      keyboardCharacters: ['r'],
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sqrt[\Box]{\Box}',
      value: r'\sqrt',
      args: [TeXArg.brackets, TeXArg.braces],
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\cos',
      value: r'\cos(',
      asTex: true,
      keyboardCharacters: ['c'],
    ),
    const BasicKeyboardButtonConfig(
      label: r'\cos^{-1}',
      value: r'\cos^{-1}(',
      asTex: true,
    ),
  ],
  [
    const BasicKeyboardButtonConfig(
      label: r'\log_{\Box}(\Box)',
      value: r'\log_',
      asTex: true,
      args: [TeXArg.braces, TeXArg.parentheses],
    ),
    const BasicKeyboardButtonConfig(
      label: r'\ln(\Box)',
      value: r'\ln(',
      asTex: true,
      keyboardCharacters: ['l'],
    ),
    const BasicKeyboardButtonConfig(
      label: r'\tan',
      value: r'\tan(',
      asTex: true,
      keyboardCharacters: ['t'],
    ),
    const BasicKeyboardButtonConfig(
      label: r'\tan^{-1}',
      value: r'\tan^{-1}(',
      asTex: true,
    ),
  ],
  [
    const PageButtonConfig(flex: 3),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      highlighted: true,
      keyboardCharacters: ['('],
      svgIcon: 'l_brace.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      highlighted: true,
      keyboardCharacters: [')'],
      svgIcon: 'r_brace.svg',
    ),
    PreviousButtonConfig(svgIcon: 'previous_char.svg'),
    NextButtonConfig(svgIcon: 'next_char.svg'),
    DeleteButtonConfig(svgIcon: 'backspace.svg'),
  ],
];

/// Standard keyboard for math expression input.
final standardKeyboard = [
  [
    // First row - Variables and basic operations
    const BasicKeyboardButtonConfig(
      label: 'x',
      value: 'x',
      keyboardCharacters: ['x'],
      longPressOptions: ['a'], // More options for better testing
      svgIcon: 'var_x.svg',
      highlighted: true,
    ),
    _digitButtons[7],
    _digitButtons[8],
    _digitButtons[9],
    const BasicKeyboardButtonConfig(
      label: '÷',
      value: r'\frac',
      keyboardCharacters: ['/'],
      args: [TeXArg.braces, TeXArg.braces],
      svgIcon: 'divide.svg',
      highlighted: true,
    ),
    DeleteButtonConfig(svgIcon: 'backspace.svg'),
  ],
  [
    // Second row - More variables and operations
    const BasicKeyboardButtonConfig(
      label: 'y',
      value: 'y',
      keyboardCharacters: ['y'],
      longPressOptions: ['b'],
      svgIcon: 'var_y.svg',
      highlighted: true,
    ),
    _digitButtons[4],
    _digitButtons[5],
    _digitButtons[6],
    const BasicKeyboardButtonConfig(
      label: '×',
      value: r'\cdot',
      keyboardCharacters: ['*'],
      svgIcon: 'multiply.svg',
      highlighted: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\frac{\Box}{\Box}',
      value: r'\frac',
      args: [TeXArg.braces, TeXArg.braces],
      asTex: true,
      svgIcon: 'fraction.svg',
    ),
  ],
  [
    // Third row - Variables and numbers
    const BasicKeyboardButtonConfig(
      label: 'z',
      value: 'z',
      keyboardCharacters: ['z'],
      longPressOptions: ['c'],
      svgIcon: 'var_z.svg',
      highlighted: true,
    ),
    _digitButtons[1],
    _digitButtons[2],
    _digitButtons[3],

    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
      highlighted: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sqrt{\Box}',
      value: r'\sqrt',
      args: [TeXArg.braces],
      asTex: true,
      svgIcon: 'sqrt.svg',
      keyboardCharacters: ['r'],
    ),
  ],
  [
    // Fourth row - Parentheses and operations
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
      longPressOptions: ['['],
      svgIcon: 'l_brace.svg',
      highlighted: true,
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
      longPressOptions: [']'],
      svgIcon: 'r_brace.svg',
      highlighted: true,
    ),
    _digitButtons[0],
    const BasicKeyboardButtonConfig(
      label: '=',
      value: '=',
      keyboardCharacters: ['='],
      longPressOptions: ['≠', '<', '>'],
      svgIcon: 'equal.svg',
      highlighted: true,
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
      highlighted: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^2',
      value: '^2',
      args: [TeXArg.braces],
      asTex: true,
      longPressOptions: ['^3'],
      svgIcon: 'power^2.svg',
    ),
  ],
  [
    // Fifth row - Navigation and controls (only 3 buttons, each taking 2 flex)
    PreviousButtonConfig(flex: 2, svgIcon: 'previous_char.svg'),
    NextButtonConfig(flex: 2, svgIcon: 'next_char.svg'),
    SubmitButtonConfig(flex: 2, svgIcon: 'commit.svg'),
  ],
];

/// Keyboard getting shown for number input only.
final numberKeyboard = [
  [
    _digitButtons[7],
    _digitButtons[8],
    _digitButtons[9],
    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
    )
  ],
  [
    _digitButtons[4],
    _digitButtons[5],
    _digitButtons[6],
  ],
  [
    _digitButtons[1],
    _digitButtons[2],
    _digitButtons[3],
    DeleteButtonConfig(svgIcon: 'backspace.svg'),
  ],
  [
    PreviousButtonConfig(svgIcon: 'previous_char.svg'),
    _digitButtons[0],
    NextButtonConfig(svgIcon: 'next_char.svg'),
    SubmitButtonConfig(svgIcon: 'commit.svg'),
  ],
];

/// Subject selection row
final subjectSelectionRow = [
  const SubjectButtonConfig(subject: MathSubject.algebra, label: 'ALG'),
  const SubjectButtonConfig(subject: MathSubject.geometry, label: 'GEO'),
  const SubjectButtonConfig(subject: MathSubject.trigonometry, label: 'TRIG'),
  const SubjectButtonConfig(subject: MathSubject.calculus, label: 'CALC'),
  const SubjectButtonConfig(subject: MathSubject.statistics, label: 'STAT'),
  const SubjectButtonConfig(subject: MathSubject.general, label: 'GEN'),
];

/// Algebra-focused keyboard configuration
final algebraKeyboard = [
  [
    const BasicKeyboardButtonConfig(
      label: 'x',
      value: 'x',
      keyboardCharacters: ['x'],
      highlighted: true,
    ),
    const BasicKeyboardButtonConfig(
      label: 'y',
      value: 'y',
      keyboardCharacters: ['y'],
      highlighted: true,
    ),
    const BasicKeyboardButtonConfig(
      label: 'z',
      value: 'z',
      keyboardCharacters: ['z'],
      highlighted: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^2',
      value: '^2',
      args: [TeXArg.braces],
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^{\Box}',
      value: '^',
      args: [TeXArg.braces],
      asTex: true,
    ),
    DeleteButtonConfig(svgIcon: 'backspace.svg'),
  ],
  [
    _digitButtons[7],
    _digitButtons[8],
    _digitButtons[9],
    const BasicKeyboardButtonConfig(
      label: '÷',
      value: r'\frac',
      keyboardCharacters: ['/'],
      args: [TeXArg.braces, TeXArg.braces],
      svgIcon: 'divide.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
    ),
  ],
  [
    _digitButtons[4],
    _digitButtons[5],
    _digitButtons[6],
    const BasicKeyboardButtonConfig(
      label: '×',
      value: r'\cdot',
      keyboardCharacters: ['*'],
      svgIcon: 'multiply.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
    ),
  ],
  [
    _digitButtons[1],
    _digitButtons[2],
    _digitButtons[3],
    const BasicKeyboardButtonConfig(
      label: '=',
      value: '=',
      keyboardCharacters: ['='],
    ),
    PreviousButtonConfig(svgIcon: 'previous_char.svg'),
    NextButtonConfig(svgIcon: 'next_char.svg'),
  ],
  [
    _digitButtons[0],
    const BasicKeyboardButtonConfig(
      label: '.',
      value: '.',
      keyboardCharacters: ['.'],
    ),
    PageButtonConfig(),
    SubmitButtonConfig(svgIcon: 'commit.svg'),
  ],
];

/// Geometry-focused keyboard configuration
final geometryKeyboard = [
  [
    const BasicKeyboardButtonConfig(
      label: r'\pi',
      value: r'\pi',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\angle',
      value: r'\angle',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\triangle',
      value: r'\triangle',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^2',
      value: '^2',
      args: [TeXArg.braces],
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sqrt{\Box}',
      value: r'\sqrt',
      args: [TeXArg.braces],
      asTex: true,
    ),
    DeleteButtonConfig(svgIcon: 'backspace.svg'),
  ],
  [
    _digitButtons[7],
    _digitButtons[8],
    _digitButtons[9],
    const BasicKeyboardButtonConfig(
      label: '÷',
      value: r'\frac',
      keyboardCharacters: ['/'],
      args: [TeXArg.braces, TeXArg.braces],
      svgIcon: 'divide.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
    ),
  ],
  [
    _digitButtons[4],
    _digitButtons[5],
    _digitButtons[6],
    const BasicKeyboardButtonConfig(
      label: '×',
      value: r'\cdot',
      keyboardCharacters: ['*'],
      svgIcon: 'multiply.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
    ),
  ],
  [
    _digitButtons[1],
    _digitButtons[2],
    _digitButtons[3],
    const BasicKeyboardButtonConfig(
      label: '=',
      value: '=',
      keyboardCharacters: ['='],
    ),
    PreviousButtonConfig(svgIcon: 'previous_char.svg'),
    NextButtonConfig(svgIcon: 'next_char.svg'),
  ],
  [
    _digitButtons[0],
    const BasicKeyboardButtonConfig(
      label: '.',
      value: '.',
      keyboardCharacters: ['.'],
    ),
    PageButtonConfig(),
    SubmitButtonConfig(svgIcon: 'commit.svg'),
  ],
];

/// Trigonometry-focused keyboard configuration
final trigonometryKeyboard = [
  [
    const BasicKeyboardButtonConfig(
      label: r'\sin',
      value: r'\sin',
      args: [TeXArg.parentheses],
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\cos',
      value: r'\cos',
      args: [TeXArg.parentheses],
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\tan',
      value: r'\tan',
      args: [TeXArg.parentheses],
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\pi',
      value: r'\pi',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^2',
      value: '^2',
      args: [TeXArg.braces],
      asTex: true,
    ),
    DeleteButtonConfig(svgIcon: 'backspace.svg'),
  ],
  [
    _digitButtons[7],
    _digitButtons[8],
    _digitButtons[9],
    const BasicKeyboardButtonConfig(
      label: '÷',
      value: r'\frac',
      keyboardCharacters: ['/'],
      args: [TeXArg.braces, TeXArg.braces],
      svgIcon: 'divide.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
    ),
  ],
  [
    _digitButtons[4],
    _digitButtons[5],
    _digitButtons[6],
    const BasicKeyboardButtonConfig(
      label: '×',
      value: r'\cdot',
      keyboardCharacters: ['*'],
      svgIcon: 'multiply.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
    ),
  ],
  [
    _digitButtons[1],
    _digitButtons[2],
    _digitButtons[3],
    const BasicKeyboardButtonConfig(
      label: '=',
      value: '=',
      keyboardCharacters: ['='],
    ),
    PreviousButtonConfig(svgIcon: 'previous_char.svg'),
    NextButtonConfig(svgIcon: 'next_char.svg'),
  ],
  [
    _digitButtons[0],
    const BasicKeyboardButtonConfig(
      label: '.',
      value: '.',
      keyboardCharacters: ['.'],
    ),
    PageButtonConfig(),
    SubmitButtonConfig(svgIcon: 'commit.svg'),
  ],
];

/// Calculus-focused keyboard configuration
final calculusKeyboard = [
  [
    const BasicKeyboardButtonConfig(
      label: r'\frac{d}{dx}',
      value: r'\frac{d}{dx}',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\int',
      value: r'\int',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\lim',
      value: r'\lim',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sum',
      value: r'\sum',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\infty',
      value: r'\infty',
      asTex: true,
    ),
    DeleteButtonConfig(svgIcon: 'backspace.svg'),
  ],
  [
    _digitButtons[7],
    _digitButtons[8],
    _digitButtons[9],
    const BasicKeyboardButtonConfig(
      label: '÷',
      value: r'\frac',
      keyboardCharacters: ['/'],
      args: [TeXArg.braces, TeXArg.braces],
      svgIcon: 'divide.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
    ),
  ],
  [
    _digitButtons[4],
    _digitButtons[5],
    _digitButtons[6],
    const BasicKeyboardButtonConfig(
      label: '×',
      value: r'\cdot',
      keyboardCharacters: ['*'],
      svgIcon: 'multiply.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
    ),
  ],
  [
    _digitButtons[1],
    _digitButtons[2],
    _digitButtons[3],
    const BasicKeyboardButtonConfig(
      label: '=',
      value: '=',
      keyboardCharacters: ['='],
    ),
    PreviousButtonConfig(svgIcon: 'previous_char.svg'),
    NextButtonConfig(svgIcon: 'next_char.svg'),
  ],
  [
    _digitButtons[0],
    const BasicKeyboardButtonConfig(
      label: '.',
      value: '.',
      keyboardCharacters: ['.'],
    ),
    PageButtonConfig(),
    SubmitButtonConfig(svgIcon: 'commit.svg'),
  ],
];

/// Statistics-focused keyboard configuration
final statisticsKeyboard = [
  [
    const BasicKeyboardButtonConfig(
      label: r'\bar{x}',
      value: r'\bar{x}',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sigma',
      value: r'\sigma',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\mu',
      value: r'\mu',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sum',
      value: r'\sum',
      asTex: true,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sqrt{\Box}',
      value: r'\sqrt',
      args: [TeXArg.braces],
      asTex: true,
    ),
    DeleteButtonConfig(svgIcon: 'backspace.svg'),
  ],
  [
    _digitButtons[7],
    _digitButtons[8],
    _digitButtons[9],
    const BasicKeyboardButtonConfig(
      label: '÷',
      value: r'\frac',
      keyboardCharacters: ['/'],
      args: [TeXArg.braces, TeXArg.braces],
      svgIcon: 'divide.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
    ),
  ],
  [
    _digitButtons[4],
    _digitButtons[5],
    _digitButtons[6],
    const BasicKeyboardButtonConfig(
      label: '×',
      value: r'\cdot',
      keyboardCharacters: ['*'],
      svgIcon: 'multiply.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
    ),
    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
    ),
  ],
  [
    _digitButtons[1],
    _digitButtons[2],
    _digitButtons[3],
    const BasicKeyboardButtonConfig(
      label: '=',
      value: '=',
      keyboardCharacters: ['='],
    ),
    PreviousButtonConfig(svgIcon: 'previous_char.svg'),
    NextButtonConfig(svgIcon: 'next_char.svg'),
  ],
  [
    _digitButtons[0],
    const BasicKeyboardButtonConfig(
      label: '.',
      value: '.',
      keyboardCharacters: ['.'],
    ),
    PageButtonConfig(),
    SubmitButtonConfig(svgIcon: 'commit.svg'),
  ],
];

/// Returns the appropriate keyboard layout for the given subject
Map<MathSubject, List<List<KeyboardButtonConfig>>> getSubjectKeyboards() {
  return {
    MathSubject.algebra: algebraKeyboard,
    MathSubject.geometry: geometryKeyboard,
    MathSubject.trigonometry: trigonometryKeyboard,
    MathSubject.calculus: calculusKeyboard,
    MathSubject.statistics: statisticsKeyboard,
    MathSubject.general: standardKeyboard,
  };
}
