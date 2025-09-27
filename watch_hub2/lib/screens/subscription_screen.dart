import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSubscribed = false;
  bool _isLoading = false;
  String? _message;

  Future<void> subscribe() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _message = 'Please enter a valid email address.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('subscribers')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _isSubscribed = true;
          _message = 'You are already subscribed!';
        });
      } else {
        await FirebaseFirestore.instance.collection('subscribers').add({
          'email': email,
          'timestamp': Timestamp.now(),
        });

        setState(() {
          _isSubscribed = true;
          _message = 'Subscription successful!';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Something went wrong. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      _emailController.text = user.email!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final goldColor = const Color(0xFFFFD700);
    final darkGold = const Color(0xFFD4AF37);
    final blackColor = Colors.black;

    return Scaffold(
      backgroundColor: blackColor,
     appBar: AppBar(
  title: const Text(
    'Premium Subscription',
    style: TextStyle(color: Colors.white),
  ),
  centerTitle: true,
  backgroundColor: blackColor,
  elevation: 0,
  iconTheme: IconThemeData(color: goldColor), // Removed const
),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Premium Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: goldColor, width: 2),
                  ),
                  child: Icon(Icons.star, size: 50, color: goldColor),
                ),
                const SizedBox(height: 20),
                
                // Title
                Text(
                  'EXCLUSIVE OFFERS',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: goldColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  _isSubscribed
                      ? 'You\'re part of our premium community!'
                      : 'Subscribe to receive exclusive deals and updates',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Email Input
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: goldColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[800]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: goldColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.email, color: goldColor),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Subscribe Button
                _isLoading
                    ? CircularProgressIndicator(color: goldColor)
                    : ElevatedButton(
                        onPressed: subscribe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          foregroundColor: blackColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          shadowColor: goldColor.withOpacity(0.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: blackColor),
                            const SizedBox(width: 10),
                            Text(
                              'BECOME PREMIUM',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                
                // Message
                if (_message != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isSubscribed 
                          ? Colors.green.withOpacity(0.2) 
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _isSubscribed ? Colors.green : Colors.red,
                      ),
                    ),
                    child: Text(
                      _message!,
                      style: TextStyle(
                        color: _isSubscribed ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                
                // Benefits (only shown when not subscribed)
                if (!_isSubscribed) ...[
                  const SizedBox(height: 40),
                  Text(
                    'PREMIUM BENEFITS',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: goldColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Column(
                    children: [
                      _buildBenefitItem('Exclusive Discounts', Icons.discount),
                      _buildBenefitItem('Early Access', Icons.access_time),
                      _buildBenefitItem('VIP Support', Icons.headset_mic),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFFFD700)),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}