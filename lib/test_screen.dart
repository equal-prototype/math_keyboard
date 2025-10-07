import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_keyboard/math_keyboard.dart';

class TestExerciseScreen extends StatefulWidget {
  const TestExerciseScreen({super.key});

  @override
  State<TestExerciseScreen> createState() => _TestExerciseScreenState();
}

class _TestExerciseScreenState extends State<TestExerciseScreen> {
  final MathFieldEditingController _mathController =
      MathFieldEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _loading = false;
  String _savedValue = '';

  @override
  void dispose() {
    _mathController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleMathStep(String value) {
    print('Math step submitted: $value');
    setState(() {
      _savedValue = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Submitted: $value')),
    );
  }

  void _handleResumeLastText() {
    print('Resume last text pressed');
    // Simulate resume behavior
    if (_savedValue.isNotEmpty) {
      _mathController.updateValue(TeXParser(_savedValue).parse());
    }
  }

  void _handleWriteFromScratch() {
    print('Write from scratch pressed');
    _mathController.clear();
  }

  void _showExerciseModal(String modalType) {
    print('Modal requested: $modalType');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Modal: $modalType')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _buildLoadingPage();
    }

    return MathKeyboardViewInsets(
      child: Builder(
        builder: (context) {
          // Get the actual math keyboard height using the proper API
          final keyboardHeight =
              MathKeyboardViewInsetsQuery.of(context).bottomInset;

          return Scaffold(
            backgroundColor: const Color(0xFFF2F4F8),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Stack(
                children: [
                  // Main content - now receives keyboard height
                  Positioned(
                    top: 100, // Fixed header height
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildMainContent(keyboardHeight),
                  ),

                  // Header
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Material(
                      elevation: 15,
                      type: MaterialType.card,
                      shadowColor: Colors.black.withOpacity(0.0),
                      child: Container(
                        decoration:
                            const BoxDecoration(color: Color(0xFFF2F4F8)),
                        child: _buildHeader(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingPage() {
    return const Scaffold(
      backgroundColor: Color(0xFFF2F4F8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF7349F2)),
            SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF7349F2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 100,
      color: const Color(0xFFF2F4F8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Test Exercise Screen',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF09162E),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(double keyboardHeight) {
    // Calculate button heights
    const stepButtonsHeight = 56.0;
    const resumeButtonsHeight = 48.0;
    const mathFieldHeight = 150.0; // Fixed height for math field
    const topButtonsHeight = 56.0; // Height for "Nuovo Foglio" button area
    const spacing = 8.0;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          // Top buttons row - fixed at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topButtonsHeight,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
              ),
              child: Row(
                children: [
                  // Spazio a sinistra (2/3 della larghezza)
                  Expanded(flex: 2, child: Container()),
                  // Pulsante "Nuovo Foglio" (1/3 della larghezza)
                  Expanded(
                    flex: 1,
                    child: _buildNewSheetButton(),
                  ),
                ],
              ),
            ),
          ),

          // Math field - anchored above resume buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: keyboardHeight +
                stepButtonsHeight +
                resumeButtonsHeight +
                spacing,
            height: mathFieldHeight,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.only(
                left: 8,
                right: 16,
                top: 16,
                bottom: 16,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: const TextSelectionThemeData(
                    cursorColor: Colors.black,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    _focusNode.requestFocus();
                  },
                  child: MathField(
                    textAlignHorizontal: TextAlignHorizontal.right,
                    controller: _mathController,
                    focusNode: _focusNode,
                    submitButtonText: 'INVIA',
                    fontSize: 36,
                    onSubmitted: (value) {
                      _handleMathStep(value);
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Resume/Write from scratch buttons - anchored above step buttons
          Positioned(
            left: 0,
            right: 0,
            bottom: keyboardHeight + stepButtonsHeight + spacing,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: Container(
                width: double.infinity,
                height: resumeButtonsHeight,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _handleResumeLastText,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: const Color(0xFF7349F2),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'RIPRENDI ULTIMO TESTO',
                            style: GoogleFonts.ibmPlexMono(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              height: 16 / 12,
                              letterSpacing: 0.0,
                              color: const Color(0xFF7349F2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SizedBox(
                        height: 18,
                        child: VerticalDivider(
                          color: const Color(0xFF09162E),
                          thickness: 1,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _handleWriteFromScratch,
                      child: Text(
                        'SCRIVI DA ZERO',
                        style: GoogleFonts.ibmPlexMono(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 16 / 12,
                          letterSpacing: 0.0,
                          color: const Color(0xFF09162E),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // StepButtons - anchored directly above keyboard
          Positioned(
            left: 0,
            right: 0,
            bottom: keyboardHeight,
            child: Container(
              height: stepButtonsHeight,
              color: const Color(0xFFF2F4F8),
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildStepButtons(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewSheetButton() {
    return ElevatedButton.icon(
      onPressed: () {
        print('Nuovo Foglio button pressed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nuovo Foglio pressed')),
        );
      },
      icon: Icon(Icons.add, size: 20, color: const Color(0xFF09162E)),
      label: Text(
        'Nuovo Foglio',
        style: GoogleFonts.ibmPlexMono(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          height: 16 / 12,
          letterSpacing: 0.0,
          color: const Color(0xFF09162E),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF09162E),
        elevation: 0,
        side: const BorderSide(
          color: Color(0xFF09162E),
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.only(left: 8),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _buildStepButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStepButton(
            icon: Icons.lightbulb_outline,
            label: 'Suggerimento',
            onPressed: () => _showExerciseModal('suggestion'),
          ),
          _buildStepButton(
            icon: Icons.bookmark_outline,
            label: 'Esempio',
            onPressed: () => _showExerciseModal('example'),
          ),
          _buildStepButton(
            icon: Icons.check_circle_outline,
            label: 'Soluzione',
            onPressed: () => _showExerciseModal('solution'),
          ),
        ],
      ),
    );
  }

  Widget _buildStepButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF2F4F8),
            foregroundColor: const Color(0xFF09162E),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
