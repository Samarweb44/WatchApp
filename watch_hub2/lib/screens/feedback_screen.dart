import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';
import '/screens/auth_screen.dart';

import '/models/app_state.dart';
import 'feedbacklist_screen.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  String _feedbackType = 'Suggestion';

  // Theme colors
  final Color _primaryBlack = const Color(0xFF121212);
  final Color _secondaryBlack = const Color(0xFF1E1E1E);
  final Color _accentYellow = const Color(0xFFFFD700);
  final Color _white = const Color(0xFFFFFFFF);
  final Color _hintColor = const Color(0xFFA0A0A0);
  final Color _successGreen = const Color(0xFF4CAF50);
  final Color _errorRed = const Color(0xFFF44336);

  bool _isLoading = false;
  bool _isSent = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize user email if available
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email != null) {
      _userController.text = currentUser.email!;
    }
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _feedbackController.dispose();
    _userController.dispose();
    super.dispose();
  }

  Future<void> submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        _buildSnackBar("Please sign in to submit feedback", _errorRed),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('feedbacks').add({
        'type': _feedbackType,
        'message': _feedbackController.text.trim(),
        'user': _userController.text.trim(),
        'userId': currentUser.uid, // Add user ID for filtering
        'userEmail': currentUser.email, // Add email for reference
        'timestamp': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar("Thank you for your feedback!", _successGreen),
        );
      }

      setState(() {
        _isLoading = false;
        _isSent = true;
        _feedbackController.clear();
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar("Error: ${e.toString()}", _errorRed),
        );
      }
    }
  }

  SnackBar _buildSnackBar(String message, Color backgroundColor) {
    return SnackBar(
      content: Text(message, style: TextStyle(color: _white)),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AppState>(context).currentUser;

    return Scaffold(
      backgroundColor: _primaryBlack,
      appBar: AppBar(
        title: const Text(
          "Feedback & Report",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _accentYellow),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryBlack.withOpacity(0.9), _primaryBlack],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          if (currentUser != null)
            IconButton(
              icon: const Icon(Icons.list_alt),
              tooltip: "View Your Feedbacks",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FeedbackListScreen()),
                );
              },
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _isSent 
            ? _buildSuccessMessage()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          if (currentUser == null) _buildLoginPrompt(),
                          if (currentUser != null) ...[
                            _buildUserField(),
                            const SizedBox(height: 16),
                            _buildTypeDropdown(),
                            const SizedBox(height: 16),
                            _buildFeedbackField(),
                            const SizedBox(height: 24),
                            _buildSubmitButton(),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'We value your feedback',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your suggestions and reports help us improve our service.',
          style: TextStyle(
            fontSize: 16,
            color: _hintColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

 Widget _buildLoginPrompt() {
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _secondaryBlack,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _accentYellow.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                color: _accentYellow,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sign In Required',
              style: TextStyle(
                color: _white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please sign in to submit your valuable feedback.',
              style: TextStyle(
                color: _white.withOpacity(0.8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentYellow,
                foregroundColor: _primaryBlack,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                shadowColor: _accentYellow.withOpacity(0.6),
              ),
              child: const Text(
                'SIGN IN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
    ],
  );
}


  Widget _buildUserField() {
    return TextFormField(
      controller: _userController,
      style: TextStyle(color: _white),
      decoration: InputDecoration(
        labelText: 'Your Name or Email',
        labelStyle: TextStyle(color: _hintColor),
        hintText: 'How should we address you?',
        hintStyle: TextStyle(color: _hintColor),
        filled: true,
        fillColor: _secondaryBlack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _accentYellow,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        prefixIcon: Icon(Icons.person, color: _hintColor),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your name or email';
        }
        return null;
      },
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _feedbackType,
      dropdownColor: _secondaryBlack,
      style: TextStyle(color: _white),
      iconEnabledColor: _accentYellow,
      decoration: InputDecoration(
        labelText: 'Feedback Type',
        labelStyle: TextStyle(color: _hintColor),
        filled: true,
        fillColor: _secondaryBlack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _accentYellow,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        prefixIcon: Icon(Icons.category, color: _hintColor),
      ),
      items: const [
        DropdownMenuItem(value: 'Suggestion', child: Text('Suggestion')),
        DropdownMenuItem(value: 'Bug Report', child: Text('Bug Report')),
        DropdownMenuItem(value: 'Other', child: Text('Other')),
      ],
      onChanged: (value) {
        setState(() {
          _feedbackType = value!;
        });
      },
    );
  }

  Widget _buildFeedbackField() {
    return TextFormField(
      controller: _feedbackController,
      maxLines: 5,
      style: TextStyle(color: _white),
      decoration: InputDecoration(
        labelText: 'Your Message',
        labelStyle: TextStyle(color: _hintColor),
        hintText: 'Describe your feedback in detail...',
        hintStyle: TextStyle(color: _hintColor),
        filled: true,
        fillColor: _secondaryBlack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: _accentYellow,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 16,
        ),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your feedback';
        }
        if (value.length < 10) {
          return 'Feedback should be at least 10 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : submitFeedback,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentYellow,
          foregroundColor: _primaryBlack,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: _accentYellow.withOpacity(0.5),
        ),
        child: _isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: _primaryBlack,
                  strokeWidth: 3,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'SUBMIT FEEDBACK',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSuccessMessage() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: _successGreen,
                  size: 100,
                ),
                const SizedBox(height: 24),
                Text(
                  'Feedback Submitted!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Thank you for helping us improve. We appreciate your input!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: _hintColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSent = false;
                        _animationController.reset();
                        _animationController.forward();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentYellow,
                      foregroundColor: _primaryBlack,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      shadowColor: _accentYellow.withOpacity(0.5),
                    ),
                    child: Text(
                      'SUBMIT MORE FEEDBACK',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'feedbacklist_screen.dart'; // Make sure this file exists

// class FeedbackScreen extends StatefulWidget {
//   const FeedbackScreen({Key? key}) : super(key: key);

//   @override
//   State<FeedbackScreen> createState() => _FeedbackScreenState();
// }

// class _FeedbackScreenState extends State<FeedbackScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _feedbackController = TextEditingController();
//   final TextEditingController _userController = TextEditingController();
//   String _feedbackType = 'Suggestion';

//   Future<void> submitFeedback() async {
//     print("🔘 Submit button clicked");

//     if (_formKey.currentState!.validate()) {
//       print("✅ Form validated");

//       try {
//         await FirebaseFirestore.instance.collection('feedbacks').add({
//           'type': _feedbackType,
//           'message': _feedbackController.text.trim(),
//           'user': _userController.text.trim(),
//           'timestamp': Timestamp.now(),
//         });

//         print("📤 Feedback submitted to Firestore");

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             backgroundColor: Colors.yellow,
//             content: const Text(
//               "Thank you for your feedback!",
//               style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//           ),
//         );

//         _feedbackController.clear();
//         _userController.clear();
//       } catch (e) {
//         print("❌ Error submitting feedback: $e");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Error: $e"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } else {
//       print("⚠️ Form validation failed");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.yellow[700],
//         centerTitle: true,
//         elevation: 0,
//         title: const Text(
//           "Feedback & Report",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.list_alt),
//             tooltip: "View Submitted Feedback",
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const FeedbackListScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Center(
//           child: Card(
//             color: Colors.grey[900],
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             elevation: 12,
//             child: Padding(
//               padding: const EdgeInsets.all(25),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     const Text(
//                       'We value your feedback',
//                       style: TextStyle(
//                         color: Colors.yellow,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     TextFormField(
//                       controller: _userController,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: 'Your Name or Email',
//                         labelStyle: const TextStyle(color: Colors.yellow),
//                         filled: true,
//                         fillColor: Colors.black,
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(color: Colors.yellow),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(color: Colors.yellow, width: 2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter your name or email';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     DropdownButtonFormField<String>(
//                       value: _feedbackType,
//                       dropdownColor: Colors.grey[850],
//                       style: const TextStyle(color: Colors.white),
//                       iconEnabledColor: Colors.yellow,
//                       decoration: InputDecoration(
//                         labelText: 'Feedback Type',
//                         labelStyle: const TextStyle(color: Colors.yellow),
//                         filled: true,
//                         fillColor: Colors.black,
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(color: Colors.yellow),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(color: Colors.yellow, width: 2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       items: const [
//                         DropdownMenuItem(value: 'Suggestion', child: Text('Suggestion')),
//                         DropdownMenuItem(value: 'Bug Report', child: Text('Bug Report')),
//                         DropdownMenuItem(value: 'Other', child: Text('Other')),
//                       ],
//                       onChanged: (value) {
//                         setState(() {
//                           _feedbackType = value!;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 20),
//                     TextFormField(
//                       controller: _feedbackController,
//                       maxLines: 5,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         labelText: 'Your Message',
//                         labelStyle: const TextStyle(color: Colors.yellow),
//                         filled: true,
//                         fillColor: Colors.black,
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(color: Colors.yellow),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(color: Colors.yellow, width: 2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.trim().isEmpty) {
//                           return 'Please enter your feedback';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 30),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         submitFeedback(); // Now wrapped for clarity
//                       },
//                       icon: const Icon(Icons.send, color: Colors.black),
//                       label: const Text(
//                         'Submit',
//                         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.yellow[700],
//                         padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
