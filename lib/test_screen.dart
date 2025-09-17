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

  bool _loading = false;
  bool _showConfirmModal = false;
  String _savedValue = '';
  String _printedValue = '';
  String _errorMessage = '';

  @override
  void dispose() {
    _mathController.dispose();
    super.dispose();
  }

  void _handleSavedValue(String userInput) {
    // Remove trailing semicolon if present
    final cleanedInput = userInput.replaceAll(RegExp(r';+\s*$'), '');
    setState(() {
      _savedValue = cleanedInput;
    });
  }

  void _handlePrintedValue(String userInput) {
    setState(() {
      _printedValue = userInput;
      _showConfirmModal = true;
    });
  }

  void _handleChange() {
    setState(() {
      _mathController.updateValue(TeXParser(_printedValue).parse());
      _showConfirmModal = false;
    });
  }

  void _handleCreateExercise() {
    print('Creating exercise: $_savedValue');
    setState(() {
      _showConfirmModal = false;
      _errorMessage = '';
    });
    // Here you can add your exercise creation logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exercise created: $_savedValue')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _buildLoadingPage();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEBF1FF),
      body: Stack(
        children: [
          Column(
            children: [
              // Header with title
              _buildHeader(),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildExerciseBox(),
                        if (_errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          _buildErrorMessage(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Modals
          if (_showConfirmModal) _buildConfirmationModal(),
        ],
      ),
    );
  }

  Widget _buildLoadingPage() {
    return const Scaffold(
      backgroundColor: Color(0xFFEBF1FF),
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
      color: const Color(0xFFEBF1FF),
      child: SafeArea(
        child: Center(
          child: Text(
            'Math Keyboard Test',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7349F2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Exercise',
            style: GoogleFonts.ibmPlexMono(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7349F2),
            ),
          ),
          const SizedBox(height: 16),

          // Math input field
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF7349F2).withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: MathField(
              controller: _mathController,
              variables: const ['x', 'y', 'z'],
              submitButtonText: 'INVIA',
              onChanged: (value) {
                _handleSavedValue(value);
              },
              onSubmitted: (value) {
                _handlePrintedValue(value);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your mathematical expression...',
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _savedValue.isNotEmpty
                  ? () => _handlePrintedValue(_savedValue)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7349F2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Let's Solve It!",
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationModal() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirm Exercise',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF7349F2),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F0FE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _printedValue,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleChange,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Needs Correction',
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleCreateExercise,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7349F2),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Let's Solve It!",
                        style: GoogleFonts.ibmPlexMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
