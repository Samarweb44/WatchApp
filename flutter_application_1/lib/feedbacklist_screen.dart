import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FeedbackListScreen extends StatelessWidget {
  const FeedbackListScreen({super.key});

  // Theme colors
  final Color _primaryBlack = const Color(0xFF121212);
  final Color _secondaryBlack = const Color(0xFF1E1E1E);
  final Color _accentYellow = const Color(0xFFFFD700);
  final Color _white = const Color(0xFFFFFFFF);
  final Color _hintColor = const Color(0xFFA0A0A0);
  final Color _errorRed = const Color(0xFFF44336);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryBlack,
      appBar: AppBar(
        title: const Text(
          "Submitted Feedbacks",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedbacks')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading feedbacks',
                style: TextStyle(color: _errorRed),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: _accentYellow),
            );
          }

          final feedbacks = snapshot.data!.docs;

          if (feedbacks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.feedback_outlined, size: 60, color: _hintColor),
                  const SizedBox(height: 16),
                  Text(
                    'No feedbacks submitted yet',
                    style: TextStyle(
                      color: _hintColor,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: feedbacks.length,
            itemBuilder: (context, index) {
              final data = feedbacks[index].data() as Map<String, dynamic>;

              final type = data['type'] ?? 'Unknown';
              final user = data['user'] ?? 'Anonymous';
              final message = data['message'] ?? '';
              final timestamp = data['timestamp'] as Timestamp?;
              final formattedTime = timestamp != null
                  ? DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp.toDate())
                  : 'Unknown time';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Card(
                  color: _secondaryBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              type,
                              style: TextStyle(
                                color: _accentYellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                color: _hintColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'From: $user',
                          style: TextStyle(
                            color: _hintColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _primaryBlack,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            message,
                            style: TextStyle(
                              color: _white,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}