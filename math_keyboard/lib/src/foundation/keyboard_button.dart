import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:math_keyboard/src/foundation/node.dart';

/// Enumeration for different subject configurations.
enum MathSubject {
  /// Functions
  functions,

  /// Trigonometry
  trigonometry,

  /// Calculus
  calculus,

  /// Statistics
  letters,

  /// Recently used symbols and expressions
  recents,

  /// General mathematics
  general,
}

/// Enumeration for button color levels.
/// 0 = #E3E5E8 (lightest)
/// 1 = #C7CCD1 (light)
/// 2 = #AEC5EF (blue)
/// 3 = #122B5A (dark blue)
enum ButtonColor {
  /// Light gray - #E3E5E8
  level0,

  /// Medium gray - #C7CCD1
  level1,

  /// Light blue - #AEC5EF
  level2,

  /// Dark blue - #122B5A
  level3,
}

/// Class representing a button configuration.
abstract class KeyboardButtonConfig {
  /// Constructs a [KeyboardButtonConfig].
  const KeyboardButtonConfig({
    this.flex,
    this.keyboardCharacters = const [],
    this.color = ButtonColor.level0,
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

  /// The color level of this button (0-3).
  final ButtonColor color;
}

/// Class representing a button configuration for a [FunctionButton].
class BasicKeyboardButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [KeyboardButtonConfig].
  const BasicKeyboardButtonConfig({
    required this.label,
    required this.value,
    this.args,
    this.asTex = false,
    this.longPressOptions,
    this.svgIcon,
    List<String> keyboardCharacters = const [],
    int? flex,
    ButtonColor color = ButtonColor.level0,
  }) : super(
          flex: flex,
          keyboardCharacters: keyboardCharacters,
          color: color,
        );

  /// The label of the button.
  final String label;

  /// The value in tex.
  final String value;

  /// List defining the arguments for the function behind this button.
  final List<TeXArg>? args;

  /// Whether to display the label as TeX or as plain text.
  final bool asTex;

  /// List of options to show on long press.
  final List<String>? longPressOptions;

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  /// When provided, this will be used instead of the label.
  final String? svgIcon;
}

/// Class representing a button configuration of the Delete Button.
class DeleteButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [DeleteButtonConfig].
  DeleteButtonConfig({
    int? flex,
    this.svgIcon,
    ButtonColor color = ButtonColor.level3,
  }) : super(flex: flex, color: color);

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  final String? svgIcon;
}

/// Class representing a button configuration of the Previous Button.
class PreviousButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [PreviousButtonConfig].
  PreviousButtonConfig({
    int? flex,
    this.svgIcon,
    ButtonColor color = ButtonColor.level0,
  }) : super(flex: flex, color: color);

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  final String? svgIcon;
}

/// Class representing a button configuration of the Next Button.
class NextButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [NextButtonConfig].
  NextButtonConfig({
    int? flex,
    this.svgIcon,
    ButtonColor color = ButtonColor.level0,
  }) : super(flex: flex, color: color);

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  final String? svgIcon;
}

/// Class representing a button configuration of the Submit Button.
class SubmitButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [SubmitButtonConfig].
  SubmitButtonConfig({
    int? flex,
    this.svgIcon,
    this.text = 'SEND',
    ButtonColor color = ButtonColor.level3,
  }) : super(flex: flex, color: color);

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  final String? svgIcon;

  /// Text to display on the submit button (e.g., 'SEND' or 'INVIA').
  /// Defaults to 'SEND'. When provided, this will be used instead of svgIcon.
  final String text;
}

/// Class representing a button configuration for subject selection.
class SubjectButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [SubjectButtonConfig].
  const SubjectButtonConfig({
    required this.subject,
    required this.label,
    this.isActive = false,
    this.svgIcon,
    this.disabled = false,
    int? flex,
    ButtonColor color = ButtonColor.level0,
  }) : super(flex: flex, color: color);

  /// The subject this button represents.
  final MathSubject subject;

  /// The label to display on the button.
  final String label;

  /// Whether this subject is currently active.
  final bool isActive;

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  /// When provided, this will be used instead of the label.
  final String? svgIcon;

  /// Whether this subject button is disabled.
  final bool disabled;
}

/// Class representing a button configuration of the Page Toggle Button.
class PageButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [PageButtonConfig].
  const PageButtonConfig({
    int? flex,
    ButtonColor color = ButtonColor.level0,
  }) : super(flex: flex, color: color);
}

/// Class representing a button configuration of the System Expressions Button.
class SystemExpressionsButtonConfig extends KeyboardButtonConfig {
  /// Constructs a [SystemExpressionsButtonConfig].
  SystemExpressionsButtonConfig({
    int? flex,
    this.svgIcon,
    ButtonColor color = ButtonColor.level3,
  }) : super(flex: flex, color: color);

  /// Optional SVG icon path (relative to assets/images/VirtualKeyboard/).
  final String? svgIcon;
}

/// Subject selection row
final subjectSelectionRow = [
  const SubjectButtonConfig(
    subject: MathSubject.general,
    label: 'GEN',
    svgIcon: 'operazioni.svg',
    color: ButtonColor.level0,
  ),
  const SubjectButtonConfig(
    subject: MathSubject.functions,
    label: 'FUN',
    svgIcon: 'functions.svg',
    disabled: true,
    color: ButtonColor.level0,
  ),
  const SubjectButtonConfig(
    subject: MathSubject.trigonometry,
    label: 'GEO',
    svgIcon: 'trigonometry.svg',
    disabled: true,
    color: ButtonColor.level0,
  ),
  const SubjectButtonConfig(
    subject: MathSubject.calculus,
    label: 'TRIG',
    svgIcon: 'calculus.svg',
    disabled: true,
    color: ButtonColor.level0,
  ),
  const SubjectButtonConfig(
    subject: MathSubject.letters,
    label: 'ABC',
    disabled: true,
    color: ButtonColor.level0,
  ),
  const SubjectButtonConfig(
    subject: MathSubject.recents,
    label: 'Recents',
    disabled: true,
    color: ButtonColor.level0,
  ),
];

/// Standard keyboard for math expression input.
final standardKeyboard = [
  [
    // First row - Variables and basic operations
    const BasicKeyboardButtonConfig(
      label: 'x',
      value: 'x',
      keyboardCharacters: ['x'],
      longPressOptions: ['z', 'y'], // More options for better testing
      svgIcon: 'var_x.svg',
      color: ButtonColor.level1,
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
      color: ButtonColor.level2,
    ),
    DeleteButtonConfig(svgIcon: 'backspace.svg'),
  ],
  [
    // Second row - More variables and operations
    const BasicKeyboardButtonConfig(
      label: '( )',
      value: '',
      args: [TeXArg.parentheses],
      keyboardCharacters: ['p'],
      longPressOptions: ['[]'],
      svgIcon: 'parentheses.svg',
      color: ButtonColor.level1,
    ),
    _digitButtons[4],
    _digitButtons[5],
    _digitButtons[6],
    const BasicKeyboardButtonConfig(
      label: '×',
      value: r'\cdot',
      keyboardCharacters: ['*'],
      svgIcon: 'multiply.svg',
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^2',
      value: '^2',
      args: [TeXArg.braces],
      asTex: true,
      longPressOptions: ['^3'],
      svgIcon: 'power^2.svg',
      color: ButtonColor.level1,
    ),
  ],
  [
    // Third row - Variables and numbers
    const BasicKeyboardButtonConfig(
      label: r'\frac{\Box}{\Box}',
      value: r'\frac',
      args: [TeXArg.braces, TeXArg.braces],
      asTex: true,
      svgIcon: 'fraction.svg',
      color: ButtonColor.level1,
    ),
    _digitButtons[1],
    _digitButtons[2],
    _digitButtons[3],

    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sqrt{\Box}',
      value: r'\sqrt',
      args: [TeXArg.braces],
      asTex: true,
      svgIcon: 'sqrt.svg',
      keyboardCharacters: ['r'],
      color: ButtonColor.level1,
    ),
  ],
  [
    // Fourth row - Parentheses and operations
    const BasicKeyboardButtonConfig(
      label: r'\Delta',
      value: r'\Delta',
      asTex: true,
      color: ButtonColor.level1,
    ),
    const BasicKeyboardButtonConfig(
      label: ',',
      value: ',',
      keyboardCharacters: [','],
      svgIcon: 'comma.svg',
      color: ButtonColor.level2,
    ),
    _digitButtons[0],
    const BasicKeyboardButtonConfig(
      label: '=',
      value: '=',
      keyboardCharacters: ['='],
      longPressOptions: ['≠', '<', '>', '≤', '≥'],
      svgIcon: 'equal.svg',
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
      color: ButtonColor.level2,
    ),
    SystemExpressionsButtonConfig(svgIcon: 'commit.svg'),
  ],
  [
    // Fifth row - Navigation and controls (only 3 buttons, each taking 2 flex)
    PreviousButtonConfig(flex: 2, svgIcon: 'previous_char.svg'),
    NextButtonConfig(flex: 2, svgIcon: 'next_char.svg'),
    SubmitButtonConfig(flex: 2, text: 'SEND'),
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
      color: ButtonColor.level3,
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
    SubmitButtonConfig(text: 'SEND'),
  ],
];

/// List access from 0 to 9 will return the appropriate digit button.
final _digitButtons = [
  for (var i = 0; i < 10; i++)
    BasicKeyboardButtonConfig(
      label: '$i',
      value: '$i',
      keyboardCharacters: ['$i'],
      svgIcon: '$i.svg',
      color: ButtonColor.level0,
    ),
];

/// Keyboard showing extended functionality.
final functionsKeyboard = [
  [
    const BasicKeyboardButtonConfig(
      label: r'\frac{\Box}{\Box}',
      value: r'\frac',
      args: [TeXArg.braces, TeXArg.braces],
      asTex: true,
      color: ButtonColor.level0,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^2',
      value: '^2',
      args: [TeXArg.braces],
      asTex: true,
      color: ButtonColor.level0,
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
      color: ButtonColor.level0,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sin',
      value: r'\sin(',
      asTex: true,
      keyboardCharacters: ['s'],
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sin^{-1}',
      value: r'\sin^{-1}(',
      asTex: true,
      color: ButtonColor.level2,
    ),
  ],
  [
    const BasicKeyboardButtonConfig(
      label: r'\sqrt{\Box}',
      value: r'\sqrt',
      args: [TeXArg.braces],
      asTex: true,
      keyboardCharacters: ['r'],
      color: ButtonColor.level0,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sqrt[\Box]{\Box}',
      value: r'\sqrt',
      args: [TeXArg.brackets, TeXArg.braces],
      asTex: true,
      color: ButtonColor.level0,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\cos',
      value: r'\cos(',
      asTex: true,
      keyboardCharacters: ['c'],
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\cos^{-1}',
      value: r'\cos^{-1}(',
      asTex: true,
      color: ButtonColor.level2,
    ),
  ],
  [
    const BasicKeyboardButtonConfig(
      label: r'\log_{\Box}(\Box)',
      value: r'\log_',
      asTex: true,
      args: [TeXArg.braces, TeXArg.parentheses],
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\ln(\Box)',
      value: r'\ln(',
      asTex: true,
      keyboardCharacters: ['l'],
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\tan',
      value: r'\tan(',
      asTex: true,
      keyboardCharacters: ['t'],
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\tan^{-1}',
      value: r'\tan^{-1}(',
      asTex: true,
      color: ButtonColor.level2,
    ),
  ],
  [
    const PageButtonConfig(flex: 3),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
      svgIcon: 'l_brace.svg',
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
      svgIcon: 'r_brace.svg',
      color: ButtonColor.level3,
    ),
    PreviousButtonConfig(svgIcon: 'previous_char.svg'),
    NextButtonConfig(svgIcon: 'next_char.svg'),
    DeleteButtonConfig(svgIcon: 'backspace.svg'),
  ],
];

/// Algebra-focused keyboard configuration
final algebraKeyboard = [
  [
    const BasicKeyboardButtonConfig(
      label: r'\lim(\Box)',
      value: r'\lim(',
      asTex: true,
      keyboardCharacters: ['l'],
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: 'y',
      value: 'y',
      keyboardCharacters: ['y'],
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: 'z',
      value: 'z',
      keyboardCharacters: ['z'],
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^2',
      value: '^2',
      args: [TeXArg.braces],
      asTex: true,
      color: ButtonColor.level0,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^{\Box}',
      value: '^',
      args: [TeXArg.braces],
      asTex: true,
      color: ButtonColor.level0,
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
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
      color: ButtonColor.level0,
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
      color: ButtonColor.level0,
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
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
      color: ButtonColor.level3,
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
      color: ButtonColor.level3,
    ),
    PreviousButtonConfig(svgIcon: 'previous_char.svg'),
    SystemExpressionsButtonConfig(svgIcon: 'commit.svg'),
  ],
  [
    _digitButtons[0],
    const BasicKeyboardButtonConfig(
      label: '.',
      value: '.',
      keyboardCharacters: ['.'],
      color: ButtonColor.level0,
    ),
    PageButtonConfig(),
    SubmitButtonConfig(text: 'SEND'),
  ],
];

/// Geometry-focused keyboard configuration
final recentsKeyboard = [
  [
    const BasicKeyboardButtonConfig(
      label: r'\pi',
      value: r'\pi',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\angle',
      value: r'\angle',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\triangle',
      value: r'\triangle',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^2',
      value: '^2',
      args: [TeXArg.braces],
      asTex: true,
      color: ButtonColor.level0,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sqrt{\Box}',
      value: r'\sqrt',
      args: [TeXArg.braces],
      asTex: true,
      color: ButtonColor.level0,
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
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
      color: ButtonColor.level0,
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
      color: ButtonColor.level0,
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
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
      color: ButtonColor.level3,
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
      color: ButtonColor.level3,
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
      color: ButtonColor.level0,
    ),
    PageButtonConfig(),
    SubmitButtonConfig(text: 'SEND'),
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
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\cos',
      value: r'\cos',
      args: [TeXArg.parentheses],
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\tan',
      value: r'\tan',
      args: [TeXArg.parentheses],
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\pi',
      value: r'\pi',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\Box^2',
      value: '^2',
      args: [TeXArg.braces],
      asTex: true,
      color: ButtonColor.level0,
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
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
      color: ButtonColor.level0,
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
      color: ButtonColor.level0,
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
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
      color: ButtonColor.level3,
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
      color: ButtonColor.level3,
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
      color: ButtonColor.level0,
    ),
    PageButtonConfig(),
    SubmitButtonConfig(text: 'SEND'),
  ],
];

/// Calculus-focused keyboard configuration
final calculusKeyboard = [
  [
    const BasicKeyboardButtonConfig(
      label: r'\frac{d}{dx}',
      value: r'\frac{d}{dx}',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\int',
      value: r'\int',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\lim',
      value: r'\lim',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sum',
      value: r'\sum',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\infty',
      value: r'\infty',
      asTex: true,
      color: ButtonColor.level2,
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
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
      color: ButtonColor.level0,
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
      color: ButtonColor.level0,
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
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
      color: ButtonColor.level3,
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
      color: ButtonColor.level3,
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
      color: ButtonColor.level0,
    ),
    PageButtonConfig(),
    SubmitButtonConfig(text: 'SEND'),
  ],
];

/// Letters-focused keyboard configuration
final lettersKeyboard = [
  [
    const BasicKeyboardButtonConfig(
      label: r'\bar{x}',
      value: r'\bar{x}',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sigma',
      value: r'\sigma',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\mu',
      value: r'\mu',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sum',
      value: r'\sum',
      asTex: true,
      color: ButtonColor.level2,
    ),
    const BasicKeyboardButtonConfig(
      label: r'\sqrt{\Box}',
      value: r'\sqrt',
      args: [TeXArg.braces],
      asTex: true,
      color: ButtonColor.level0,
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
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '(',
      value: '(',
      keyboardCharacters: ['('],
      color: ButtonColor.level0,
    ),
    const BasicKeyboardButtonConfig(
      label: ')',
      value: ')',
      keyboardCharacters: [')'],
      color: ButtonColor.level0,
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
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '+',
      value: '+',
      keyboardCharacters: ['+'],
      svgIcon: 'add.svg',
      color: ButtonColor.level3,
    ),
    const BasicKeyboardButtonConfig(
      label: '−',
      value: '-',
      keyboardCharacters: ['-'],
      svgIcon: 'subtract.svg',
      color: ButtonColor.level3,
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
      color: ButtonColor.level3,
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
      color: ButtonColor.level0,
    ),
    PageButtonConfig(),
    SubmitButtonConfig(text: 'SEND'),
  ],
];

/// Returns the appropriate keyboard layout for the given subject
Map<MathSubject, List<List<KeyboardButtonConfig>>> getSubjectKeyboards() {
  return {
    MathSubject.functions: functionsKeyboard,
    MathSubject.trigonometry: trigonometryKeyboard,
    MathSubject.calculus: calculusKeyboard,
    MathSubject.letters: lettersKeyboard,
    MathSubject.recents: recentsKeyboard,
    MathSubject.general: standardKeyboard,
  };
}
