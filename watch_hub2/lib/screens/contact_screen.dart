// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ContactScreen extends StatefulWidget {
//   const ContactScreen({super.key});

//   @override
//   State<ContactScreen> createState() => _ContactScreenState();
// }

// class _ContactScreenState extends State<ContactScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _subjectController = TextEditingController();
//   final TextEditingController _messageController = TextEditingController();
//   final _auth = FirebaseAuth.instance;
//   final _firestore = FirebaseFirestore.instance;

//   // Theme colors
//   final Color _primaryBlack = const Color(0xFF121212);
//   final Color _secondaryBlack = const Color(0xFF1E1E1E);
//   final Color _accentYellow = const Color(0xFFFFD700);
//   final Color _white = const Color(0xFFFFFFFF);
//   final Color _hintColor = const Color(0xFFA0A0A0);

//   bool _isLoading = false;
//   bool _isSent = false;

//   Future<void> _sendMessage() async {
//     if (!_formKey.currentState!.validate()) return;

//     final user = _auth.currentUser;
//     if (user == null) return;

//     setState(() => _isLoading = true);

//     try {
//       await _firestore.collection('contact_messages').add({
//         'userId': user.uid,
//         'email': user.email,
//         'subject': _subjectController.text.trim(),
//         'message': _messageController.text.trim(),
//         'status': 'pending', // pending, read, resolved
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       setState(() {
//         _isLoading = false;
//         _isSent = true;
//       });

//       // Clear form
//       _subjectController.clear();
//       _messageController.clear();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Message sent successfully!'),
//           backgroundColor: _accentYellow,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       );
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to send message: ${e.toString()}'),
//           backgroundColor: Colors.red[400],
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _subjectController.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _primaryBlack,
//       appBar: AppBar(
//         title: const Text('Contact Us'),
//         backgroundColor: _primaryBlack,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: _accentYellow),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: _isSent
//             ? _buildSuccessMessage()
//             : Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'We\'re here to help!',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: _white,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Send us your questions or feedback and we\'ll get back to you as soon as possible.',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: _hintColor,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     TextFormField(
//                       controller: _subjectController,
//                       style: TextStyle(color: _white),
//                       decoration: InputDecoration(
//                         labelText: 'Subject',
//                         labelStyle: TextStyle(color: _hintColor),
//                         hintText: 'What\'s this about?',
//                         hintStyle: TextStyle(color: _hintColor),
//                         filled: true,
//                         fillColor: _secondaryBlack,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(
//                             color: _accentYellow,
//                             width: 1.5,
//                           ),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 16,
//                           horizontal: 16,
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a subject';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _messageController,
//                       style: TextStyle(color: _white),
//                       maxLines: 6,
//                       decoration: InputDecoration(
//                         labelText: 'Message',
//                         labelStyle: TextStyle(color: _hintColor),
//                         hintText: 'Type your message here...',
//                         hintStyle: TextStyle(color: _hintColor),
//                         filled: true,
//                         fillColor: _secondaryBlack,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide.none,
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide(
//                             color: _accentYellow,
//                             width: 1.5,
//                           ),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 16,
//                           horizontal: 16,
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your message';
//                         }
//                         if (value.length < 10) {
//                           return 'Message should be at least 10 characters';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _sendMessage,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: _accentYellow,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         child: _isLoading
//                             ? SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   color: _primaryBlack,
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                             : Text(
//                                 'SEND MESSAGE',
//                                 style: TextStyle(
//                                   color: _primaryBlack,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Icon(Icons.email, color: _accentYellow, size: 16),
//                         const SizedBox(width: 8),
//                         Text(
//                           'support@example.com',
//                           style: TextStyle(
//                             color: _hintColor,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(width: 16),
//                     Row(
//                       children: [
//                         Icon(Icons.phone, color: _accentYellow, size: 16),
//                         const SizedBox(width: 8),
//                         Text(
//                           '+1 (123) 456-7890',
//                           style: TextStyle(
//                             color: _hintColor,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildSuccessMessage() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(
//           Icons.check_circle_outline,
//           color: _accentYellow,
//           size: 80,
//         ),
//         const SizedBox(height: 24),
//         Text(
//           'Message Sent!',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: _white,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           'Thank you for contacting us. We\'ll get back to you soon.',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 16,
//             color: _hintColor,
//           ),
//         ),
//         const SizedBox(height: 32),
//         SizedBox(
//           width: double.infinity,
//           child: ElevatedButton(
//             onPressed: () => setState(() => _isSent = false),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _accentYellow,
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text(
//               'SEND ANOTHER MESSAGE',
//               style: TextStyle(
//                 color: _primaryBlack,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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
  List<Map<String, dynamic>> _messages = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    
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
    
    // Start animation after build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    final user = _auth.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar('Please sign in to view messages', _errorRed),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('contact_messages')
          .where('userId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .get();

      final List<Map<String, dynamic>> messages = [];
      
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        messages.add({
          'id': doc.id,
          'subject': data['subject'] ?? 'No Subject',
          'message': data['message'] ?? 'No Message',
          'status': data['status'] ?? 'pending',
          'createdAt': (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'adminReply': data['adminReply'],
          'repliedAt': (data['repliedAt'] as Timestamp?)?.toDate(),
        });
      }

      if (mounted) {
        setState(() {
          _messages = messages;
          _isLoading = false;
        });
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar('Database error: ${e.message}', _errorRed),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar('Error loading messages: $e', _errorRed),
        );
      }
    }
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _auth.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar('Please sign in to send messages', _errorRed),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _firestore.collection('contact_messages').add({
        'userId': user.uid,
        'email': user.email,
        'subject': _subjectController.text.trim(),
        'message': _messageController.text.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'adminReply': null,
        'repliedAt': null,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar('Message sent successfully!', _successGreen),
        );
      }

      await _fetchMessages(); // Refresh the list

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSent = true;
          _subjectController.clear();
          _messageController.clear();
        });
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar('Failed to send: ${e.message}', _errorRed),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          _buildSnackBar('Failed to send: $e', _errorRed),
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
    return Scaffold(
      backgroundColor: _primaryBlack,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _isSent
                ? _buildSuccessMessage()
                : _buildContactForm(),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
     
      title: const Text(
        'Contact Us',
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
        if (_messages.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => _buildMessagesHistorySheet(),
              );
            },
            tooltip: 'Message History',
          ),
      ],
    );
  }

  Widget _buildContactForm() {
    return FadeTransition(
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
              _buildSubjectField(),
              const SizedBox(height: 16),
              _buildMessageField(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              // const SizedBox(height: 24),
              // _buildContactInfo(),
            ],
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
          'We\'re here to help!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Send us your questions or feedback and we\'ll get back to you as soon as possible.',
          style: TextStyle(
            fontSize: 16,
            color: _hintColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectField() {
    return TextFormField(
      controller: _subjectController,
      style: TextStyle(color: _white),
      decoration: InputDecoration(
        labelText: 'Subject',
        labelStyle: TextStyle(color: _hintColor),
        hintText: 'What\'s this about?',
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
        prefixIcon: Icon(Icons.subject, color: _hintColor),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a subject';
        }
        return null;
      },
    );
  }

  Widget _buildMessageField() {
    return TextFormField(
      controller: _messageController,
      style: TextStyle(color: _white),
      maxLines: 6,
      decoration: InputDecoration(
        labelText: 'Message',
        labelStyle: TextStyle(color: _hintColor),
        hintText: 'Type your message here...',
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
        if (value == null || value.isEmpty) {
          return 'Please enter your message';
        }
        if (value.length < 10) {
          return 'Message should be at least 10 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _sendMessage,
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
                    'SEND MESSAGE',
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

  // Widget _buildContactInfo() {
  //   return Column(
  //     children: [
  //       _buildContactItem(
  //         icon: Icons.email,
  //         text: 'watchHub@gmail.com',
  //       ),
  //       const SizedBox(height: 12),
  //       _buildContactItem(
  //         icon: Icons.phone,
  //         text: '+1 (123) 456-7890',
  //       ),
  //       const SizedBox(height: 12),
  //       _buildContactItem(
  //         icon: Icons.access_time,
  //         text: 'Mon-Fri: 9AM - 5PM',
  //       ),
  //     ],
  //   );
  // }

  Widget _buildContactItem({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: _secondaryBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: _accentYellow, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(color: _hintColor, fontSize: 14),
          ),
        ],
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
                  'Message Sent!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Thank you for contacting us. We\'ll get back to you soon.',
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
                      'SEND ANOTHER MESSAGE',
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

  Widget _buildMessagesHistorySheet() {
    return Container(
      decoration: BoxDecoration(
        color: _secondaryBlack,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(top: 16),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: _hintColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Your Messages',
              style: TextStyle(
                color: _white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(color: _accentYellow),
                  )
                : _messages.isEmpty
                    ? Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(color: _hintColor),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return _buildMessageCard(message);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(Map<String, dynamic> message) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: _primaryBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          message['subject'],
          style: TextStyle(
            color: _white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, yyyy - hh:mm a').format(message['createdAt']),
              style: TextStyle(color: _hintColor, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(message['status']),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message['status'].toUpperCase(),
                style: TextStyle(
                  color: _white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMessageSection(
                  title: 'Your Message:',
                  content: message['message'],
                ),
                const SizedBox(height: 16),
                if (message['adminReply'] != null) ...[
                  _buildMessageSection(
                    title: 'Admin Reply:',
                    content: message['adminReply'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Replied on: ${DateFormat('MMM dd, yyyy - hh:mm a').format(message['repliedAt'])}',
                    style: TextStyle(color: _hintColor, fontSize: 12),
                  ),
                ] else ...[
                  Text(
                    'Status: ${message['status']}',
                    style: TextStyle(
                      color: _hintColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: _accentYellow,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
            color: _secondaryBlack,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: TextStyle(color: _white, height: 1.5),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange.withOpacity(0.8);
      case 'read':
        return Colors.blue.withOpacity(0.8);
      case 'resolved':
        return _successGreen.withOpacity(0.8);
      default:
        return _hintColor.withOpacity(0.8);
    }
  }
}