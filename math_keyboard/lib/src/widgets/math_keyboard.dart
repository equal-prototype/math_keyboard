import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:math_keyboard/src/custom_key_icons/custom_key_icons.dart';
import 'package:math_keyboard/src/foundation/keyboard_button.dart';
import 'package:math_keyboard/src/widgets/decimal_separator.dart';
import 'package:math_keyboard/src/widgets/math_field.dart';
import 'package:math_keyboard/src/widgets/view_insets.dart';

/// Class representing a button option for long press menus.
class ButtonOption {
  const ButtonOption({
    required this.label,
    required this.value,
    this.onTap,
    this.asTex = false,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool asTex;
}

/// Enumeration for the types of keyboard that a math keyboard can adopt.
///
/// This way we allow different button configurations. The user may only need to
/// input a number.
enum MathKeyboardType {
  /// Keyboard for entering complete math expressions.
  ///
  /// This shows numbers + operators and a toggle button to switch to another
  /// page with extended functions.
  expression,

  /// Keyboard for number input only.
  numberOnly,
}

/// Widget displaying the math keyboard.
class MathKeyboard extends StatelessWidget {
  /// Constructs a [MathKeyboard].
  const MathKeyboard({
    Key? key,
    required this.controller,
    this.type = MathKeyboardType.expression,
    this.variables = const [],
    this.onSubmit,
    this.insetsState,
    this.slideAnimation,
    this.padding = const EdgeInsets.only(
      bottom: 4,
      left: 4,
      right: 4,
    ),
  }) : super(key: key);

  /// The controller for editing the math field.
  ///
  /// Must not be `null`.
  final MathFieldEditingController controller;

  /// The state for reporting the keyboard insets.
  ///
  /// If `null`, the math keyboard will not report about its bottom inset.
  final MathKeyboardViewInsetsState? insetsState;

  /// Animation that indicates the current slide progress of the keyboard.
  ///
  /// If `null`, the keyboard is always fully slided out.
  final Animation<double>? slideAnimation;

  /// The Variables a user can use.
  final List<String> variables;

  /// The Type of the Keyboard.
  final MathKeyboardType type;

  /// Function that is called when the enter / submit button is tapped.
  ///
  /// Can be `null`.
  final VoidCallback? onSubmit;

  /// Insets of the keyboard.
  ///
  /// Defaults to `const EdgeInsets.only(bottom: 4, left: 4, right: 4),`.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final curvedSlideAnimation = CurvedAnimation(
      parent: slideAnimation ?? AlwaysStoppedAnimation(1),
      curve: Curves.ease,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: const Offset(0, 0),
      ).animate(curvedSlideAnimation),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Material(
              type: MaterialType.transparency,
              child: ColoredBox(
                color: const Color(0xFFF2F4F8), // Light gray background
                child: SafeArea(
                  top: false,
                  child: _KeyboardBody(
                    insetsState: insetsState,
                    slideAnimation:
                        slideAnimation == null ? null : curvedSlideAnimation,
                    child: Padding(
                      padding: padding,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 5e2,
                          ),
                          child: Column(
                            children: [
                              // if (type != MathKeyboardType.numberOnly)
                              //   _Variables(
                              //     controller: controller,
                              //     variables: variables,
                              //   ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 4,
                                ),
                                child: _Buttons(
                                  controller: controller,
                                  page1: type == MathKeyboardType.numberOnly
                                      ? numberKeyboard
                                      : standardKeyboard,
                                  page2: type == MathKeyboardType.numberOnly
                                      ? null
                                      : functionKeyboard,
                                  onSubmit: onSubmit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget that reports about the math keyboard body's bottom inset.
class _KeyboardBody extends StatefulWidget {
  const _KeyboardBody({
    Key? key,
    this.insetsState,
    this.slideAnimation,
    required this.child,
  }) : super(key: key);

  final MathKeyboardViewInsetsState? insetsState;

  /// The animation for sliding the keyboard.
  ///
  /// This is used in the body for reporting fractional sliding progress, i.e.
  /// reporting a smaller size while sliding.
  final Animation<double>? slideAnimation;

  final Widget child;

  @override
  _KeyboardBodyState createState() => _KeyboardBodyState();
}

class _KeyboardBodyState extends State<_KeyboardBody> {
  @override
  void initState() {
    super.initState();

    widget.slideAnimation?.addListener(_handleAnimation);
  }

  @override
  void didUpdateWidget(_KeyboardBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.insetsState != widget.insetsState) {
      _removeInsets(oldWidget.insetsState);
      _reportInsets(widget.insetsState);
    }

    if (oldWidget.slideAnimation != widget.slideAnimation) {
      oldWidget.slideAnimation?.removeListener(_handleAnimation);
      widget.slideAnimation?.addListener(_handleAnimation);
    }
  }

  @override
  void dispose() {
    _removeInsets(widget.insetsState);
    widget.slideAnimation?.removeListener(_handleAnimation);

    super.dispose();
  }

  void _handleAnimation() {
    _reportInsets(widget.insetsState);
  }

  void _removeInsets(MathKeyboardViewInsetsState? insetsState) {
    if (insetsState == null) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.insetsState![ObjectKey(this)] = null;
    });
  }

  void _reportInsets(MathKeyboardViewInsetsState? insetsState) {
    if (insetsState == null) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final renderBox = context.findRenderObject() as RenderBox;
      insetsState[ObjectKey(this)] =
          renderBox.size.height * (widget.slideAnimation?.value ?? 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    _reportInsets(widget.insetsState);
    return widget.child;
  }
}

/// Widget showing the variables a user can use.
// class _Variables extends StatelessWidget {
//   /// Constructs a [_Variables] Widget.
//   const _Variables({
//     Key? key,
//     required this.controller,
//     required this.variables,
//   }) : super(key: key);

//   /// The editing controller for the math field that the variables are connected
//   /// to.
//   final MathFieldEditingController controller;

//   /// The variables to show.
//   final List<String> variables;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 54,
//       color:
//           const Color(0xFFD0D0D0), // Slightly darker gray for variables section
//       child: AnimatedBuilder(
//         animation: controller,
//         builder: (context, child) {
//           return ListView.separated(
//             itemCount: variables.length,
//             scrollDirection: Axis.horizontal,
//             separatorBuilder: (context, index) {
//               return Center(
//                 child: Container(
//                   height: 24,
//                   width: 1,
//                   color: Colors.black54,
//                 ),
//               );
//             },
//             itemBuilder: (context, index) {
//               return SizedBox(
//                 width: 56,
//                 child: _VariableButton(
//                   name: variables[index],
//                   onTap: () => controller.addLeaf('{${variables[index]}}'),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

/// Widget displaying the buttons.
class _Buttons extends StatelessWidget {
  /// Constructs a [_Buttons] Widget.
  const _Buttons({
    Key? key,
    required this.controller,
    this.page1,
    this.page2,
    this.onSubmit,
  }) : super(key: key);

  /// The editing controller for the math field that the variables are connected
  /// to.
  final MathFieldEditingController controller;

  /// The buttons to display.
  final List<List<KeyboardButtonConfig>>? page1;

  /// The buttons to display.
  final List<List<KeyboardButtonConfig>>? page2;

  /// Function that is called when the enter / submit button is tapped.
  ///
  /// Can be `null`.
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 241, // Increased height for 5 rows (5 * 56 + padding)
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final layout =
              controller.secondPage ? page2! : page1 ?? numberKeyboard;
          return Column(
            children: [
              for (final row in layout)
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      for (final config in row)
                        if (config is BasicKeyboardButtonConfig)
                          _BasicButton(
                            flex: config.flex,
                            label: config.label,
                            svgIcon: config.svgIcon,
                            onTap: config.args != null
                                ? () => controller.addFunction(
                                      config.value,
                                      config.args!,
                                    )
                                : () => controller.addLeaf(config.value),
                            asTex: config.asTex,
                            highlightLevel: config.highlighted ? 1 : 0,
                            longPressOptions: config.longPressOptions
                                ?.map((option) => ButtonOption(
                                      label: option,
                                      value: option,
                                      onTap: () => controller.addLeaf(option),
                                    ))
                                .toList(),
                          )
                        else if (config is DeleteButtonConfig)
                          _NavigationButton(
                            flex: config.flex,
                            icon: Icons.backspace_outlined,
                            svgIcon: config.svgIcon,
                            iconSize: 25,
                            onTap: () => controller.goBack(deleteMode: true),
                            highlightLevel: 2, // Same as submit button
                          )
                        else if (config is PageButtonConfig)
                          _BasicButton(
                            flex: config.flex,
                            icon: controller.secondPage
                                ? null
                                : CustomKeyIcons.key_symbols,
                            label: controller.secondPage ? '123' : null,
                            onTap: controller.togglePage,
                            highlightLevel: 1,
                          )
                        else if (config is PreviousButtonConfig)
                          _NavigationButton(
                            flex: config.flex,
                            icon: Icons.chevron_left_rounded,
                            svgIcon: config.svgIcon,
                            onTap: controller.goBack,
                          )
                        else if (config is NextButtonConfig)
                          _NavigationButton(
                            flex: config.flex,
                            icon: Icons.chevron_right_rounded,
                            svgIcon: config.svgIcon,
                            onTap: controller.goNext,
                          )
                        else if (config is SubmitButtonConfig)
                          _NavigationButton(
                            flex: config.flex,
                            icon: Icons.keyboard_return,
                            svgIcon: config.svgIcon,
                            onTap: onSubmit,
                            highlightLevel: 2,
                          ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Widget displaying a single keyboard button.
class _BasicButton extends StatefulWidget {
  /// Constructs a [_BasicButton].
  const _BasicButton({
    Key? key,
    required this.flex,
    this.label,
    this.icon,
    this.svgIcon,
    this.onTap,
    this.longPressOptions,
    this.asTex = false,
    this.highlightLevel = 0,
  })  : assert(label != null || icon != null || svgIcon != null),
        super(key: key);

  /// The flexible flex value.
  final int? flex;

  /// The label for this button.
  final String? label;

  /// Icon for this button.
  final IconData? icon;

  /// SVG icon path for this button (relative to assets/images/VirtualKeyboard/).
  final String? svgIcon;

  /// Function to be called on tap.
  final VoidCallback? onTap;

  /// List of options to show on long press.
  final List<ButtonOption>? longPressOptions;

  /// Show label as tex.
  final bool asTex;

  /// Whether this button should be highlighted.
  final int highlightLevel;

  @override
  State<_BasicButton> createState() => _BasicButtonState();
}

class _BasicButtonState extends State<_BasicButton> {
  OverlayEntry? _overlayEntry;
  int _selectedIndex = -1;
  bool _isLongPressing = false;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  /// Removes the overlay menu from the screen.
  ///
  /// This method safely removes the overlay entry if it exists and sets it to null.
  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  /// Handles the start of a long press gesture.
  ///
  /// When a long press is detected, this method initializes the long press state
  /// and displays the overlay menu with available options.
  void _onLongPressStart(LongPressStartDetails details) {
    if (widget.longPressOptions == null || widget.longPressOptions!.isEmpty)
      return;

    // Remove any existing overlay first
    _removeOverlay();

    setState(() {
      _isLongPressing = true;
      _selectedIndex = -1;
    });

    _showLongPressMenu();
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (!_isLongPressing || _overlayEntry == null) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset buttonOffset = renderBox.localToGlobal(Offset.zero);
    final Size buttonSize = renderBox.size;

    // Calculate which option is being hovered
    const double popupWidth = 120.0; // Match the popup width
    const double itemHeight = 50.0; // Match the item height
    final double popupLeft =
        buttonOffset.dx + (buttonSize.width - popupWidth) / 2;
    final double popupTop =
        buttonOffset.dy - (widget.longPressOptions!.length * itemHeight) - 8;

    final Offset globalPosition = details.globalPosition;

    // Check if finger is within popup bounds
    if (globalPosition.dx >= popupLeft &&
        globalPosition.dx <= popupLeft + popupWidth &&
        globalPosition.dy >= popupTop &&
        globalPosition.dy <=
            popupTop + (widget.longPressOptions!.length * itemHeight)) {
      final int newIndex =
          ((globalPosition.dy - popupTop) / itemHeight).floor();
      if (newIndex >= 0 && newIndex < widget.longPressOptions!.length) {
        if (_selectedIndex != newIndex) {
          setState(() {
            _selectedIndex = newIndex;
          });
          _updateOverlay();
        }
      }
    } else {
      // Finger is outside popup area
      if (_selectedIndex != -1) {
        setState(() {
          _selectedIndex = -1;
        });
        _updateOverlay();
      }
    }
  }

  /// Handles the end of a long press gesture without pan movement.
  ///
  /// This method is called when a long press ends without any sliding movement.
  /// It executes the main button action if no option was selected via sliding.
  void _onLongPressEnd(LongPressEndDetails details) {
    if (!_isLongPressing) return;

    setState(() {
      _isLongPressing = false;
    });

    // Execute selected option or main button action
    if (_selectedIndex >= 0 &&
        _selectedIndex < widget.longPressOptions!.length) {
      widget.longPressOptions![_selectedIndex].onTap?.call();
    } else {
      widget.onTap?.call();
    }

    _removeOverlay();
    _selectedIndex = -1;
  }

  void _showLongPressMenu() {
    if (widget.longPressOptions == null || widget.longPressOptions!.isEmpty)
      return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    // Calculate popup width (make it more square-like)
    const double popupWidth = 60.0; // Increased width for better visibility
    const double itemHeight = 50.0; // Increased height for easier touch
    final double totalHeight = widget.longPressOptions!.length * itemHeight;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + (size.width - popupWidth) / 2,
        top: offset.dy - totalHeight - 8,
        child: Material(
          elevation: 8,
          child: Container(
            width: popupWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.longPressOptions!.asMap().entries.map((entry) {
                final int index = entry.key;
                final ButtonOption option = entry.value;
                final bool isSelected = index == _selectedIndex;

                return Container(
                  width: popupWidth,
                  height: itemHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF7349F2)
                            .withOpacity(0.3) // More visible selection
                        : Colors.transparent,
                    border: isSelected
                        ? Border.all(color: const Color(0xFF7349F2), width: 2)
                        : null,
                  ),
                  child: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 18, // Increased font size
                      fontWeight: FontWeight.w600, // Bolder text
                      color:
                          isSelected ? const Color(0xFF7349F2) : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (widget.svgIcon != null) {
      // Use SVG icon if provided
      result = SvgPicture.asset(
        'assets/images/VirtualKeyboard/${widget.svgIcon}',
        package: 'math_keyboard',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(
          Colors.black87,
          BlendMode.srcIn,
        ),
      );
    } else if (widget.label == null) {
      result = Icon(
        widget.icon,
        color: Colors.white,
        size: 20,
      );
    } else if (widget.asTex) {
      result = Math.tex(
        widget.label!,
        options: MathOptions(
          fontSize: 20,
          color: Colors.black87,
        ),
      );
    } else {
      var symbol = widget.label;
      if (widget.label == '.') {
        // We want to display the decimal separator differently depending
        // on the current locale.
        symbol = decimalSeparator(context);
      }

      result = Text(
        symbol!,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      );
    }

    // Determine button color based on highlight level and content
    Color buttonColor;
    if (widget.highlightLevel > 1) {
      buttonColor = const Color(0xFF09162E); // Dark blue for submit
    } else if (widget.highlightLevel == 1) {
      buttonColor = const Color(0xFFC1C7CD); // Medium gray for special buttons
    } else {
      // Different colors for different button types
      buttonColor = const Color(0xFFDDE1E6); // Gray for operators
    }

    // Check if this is a number button (0-9)
    bool isNumberButton =
        widget.label != null && RegExp(r'^[0-9]$').hasMatch(widget.label!);

    Widget buttonWidget = Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: buttonColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (widget.longPressOptions != null &&
                  widget.longPressOptions!.isNotEmpty)
              ? null // Disable tap if there are long press options
              : widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: isNumberButton
                    ? Container(
                        margin: const EdgeInsets.all(
                            1), // 1px margin from button edge
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: result,
                        ),
                      )
                    : result,
              ),
              // Add white dot indicator for buttons with long press options
              if (widget.longPressOptions != null &&
                  widget.longPressOptions!.isNotEmpty)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    // Wrap with gesture detector if there are long press options
    if (widget.longPressOptions != null &&
        widget.longPressOptions!.isNotEmpty) {
      buttonWidget = GestureDetector(
        onTap: widget.onTap, // Handle regular taps here
        onLongPressStart: _onLongPressStart,
        onLongPressMoveUpdate: _onLongPressMoveUpdate,
        onLongPressEnd: _onLongPressEnd,
        child: buttonWidget,
      );
    }

    return Expanded(
      flex: widget.flex ?? 2,
      child: buttonWidget,
    );
  }
}

/// Keyboard button for navigation actions.
class _NavigationButton extends StatelessWidget {
  /// Constructs a [_NavigationButton].
  const _NavigationButton({
    Key? key,
    required this.flex,
    this.icon,
    this.svgIcon,
    this.iconSize = 36,
    this.onTap,
    this.highlightLevel = 0,
  }) : super(key: key);

  /// The flexible flex value.
  final int? flex;

  /// Icon to be shown.
  final IconData? icon;

  /// SVG icon path for this button (relative to assets/images/VirtualKeyboard/).
  final String? svgIcon;

  /// The size for the icon.
  final double iconSize;

  /// Function used when user holds the button down.
  final VoidCallback? onTap;

  /// Whether this button should be highlighted.
  final int highlightLevel;

  @override
  Widget build(BuildContext context) {
    // Determine button color and icon color based on highlight level
    Color buttonColor;
    Color iconColor;

    if (highlightLevel > 1) {
      buttonColor = const Color(0xFF09162E); // Dark blue like submit button
      iconColor = Colors.white;
    } else if (highlightLevel == 0) {
      buttonColor =
          const Color(0xFFDDE1E6); // Same as non-highlighted basic buttons
      iconColor = Colors.black87;
    } else {
      buttonColor =
          const Color(0xFFB8B8B8); // Default gray for other highlight levels
      iconColor = Colors.black87;
    }

    Widget iconWidget;
    if (svgIcon != null) {
      // Use SVG icon if provided
      iconWidget = SvgPicture.asset(
        'assets/images/VirtualKeyboard/$svgIcon',
        package: 'math_keyboard',
        width: iconSize * 0.6,
        height: iconSize * 0.6,
        colorFilter: ColorFilter.mode(
          iconColor,
          BlendMode.srcIn,
        ),
      );
    } else {
      // Use regular icon
      iconWidget = Icon(
        icon,
        color: iconColor,
        size: iconSize * 0.8, // Slightly smaller icons
      );
    }

    return Expanded(
      flex: flex ?? 2,
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: buttonColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              alignment: Alignment.center,
              child: iconWidget,
            ),
          ),
        ),
      ),
    );
  }
}
