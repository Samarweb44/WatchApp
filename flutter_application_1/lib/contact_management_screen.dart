import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminContactScreen extends StatefulWidget {
  const AdminContactScreen({super.key});

  @override
  State<AdminContactScreen> createState() => _AdminContactScreenState();
}

class _AdminContactScreenState extends State<AdminContactScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _searchController = TextEditingController();

  // Theme colors
  final Color _primaryBlack = const Color(0xFF121212);
  final Color _secondaryBlack = const Color(0xFF1E1E1E);
  final Color _accentYellow = const Color(0xFFFFD700);
  final Color _white = const Color(0xFFFFFFFF);
  final Color _hintColor = const Color(0xFFA0A0A0);

  String _filterStatus = 'all'; // all, pending, read, resolved
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _updateMessageStatus(String docId, String status) async {
    try {
      await _firestore.collection('contact_messages').doc(docId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: ${e.toString()}'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  Future<void> _deleteMessage(String docId) async {
    try {
      await _firestore.collection('contact_messages').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Message deleted successfully.'),
          backgroundColor: Colors.green[600],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete message: $e'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  Future<void> _sendAdminReply(String docId, String email) async {
    final TextEditingController _replyController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _secondaryBlack,
          title: Text('Reply to $email', style: TextStyle(color: _white)),
          content: TextField(
            controller: _replyController,
            maxLines: 5,
            style: TextStyle(color: _white),
            decoration: InputDecoration(
              hintText: 'Write your reply...',
              hintStyle: TextStyle(color: _hintColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: _accentYellow),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                final reply = _replyController.text.trim();
                if (reply.isNotEmpty) {
                  try {
                    await _firestore
                        .collection('contact_messages')
                        .doc(docId)
                        .update({
                          'adminReply': reply,
                          'repliedAt': FieldValue.serverTimestamp(),
                          'status': 'resolved',
                        });
                    Navigator.pop(context);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Reply sent successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to send reply: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: Text('Send', style: TextStyle(color: _accentYellow)),
            ),
          ],
        );
      },
    );
  }
  // void _showReplyDialog(String email) {
  //   final TextEditingController _replyController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         backgroundColor: _secondaryBlack,
  //         title: Text('Reply to $email', style: TextStyle(color: _white)),
  //         content: TextField(
  //           controller: _replyController,
  //           maxLines: 5,
  //           style: TextStyle(color: _white),
  //           decoration: InputDecoration(
  //             hintText: 'Write your reply...',
  //             hintStyle: TextStyle(color: _hintColor),
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: _accentYellow),
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context),
  //             child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               final reply = _replyController.text.trim();
  //               if (reply.isNotEmpty) {
  //                 // Optionally store reply in Firestore or send email here
  //                 Navigator.pop(context);
  //                 ScaffoldMessenger.of(context).showSnackBar(
  //                   SnackBar(
  //                     content: const Text('Reply sent (simulated).'),
  //                     backgroundColor: Colors.blue[600],
  //                   ),
  //                 );
  //               }
  //             },
  //             child: Text('Send', style: TextStyle(color: _accentYellow)),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'read':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      default:
        return _hintColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryBlack,
      appBar: AppBar(
        title: const Text('Contact Messages'),
        backgroundColor: _primaryBlack,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _accentYellow),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: _white),
                    decoration: InputDecoration(
                      hintText: 'Search messages...',
                      hintStyle: TextStyle(color: _hintColor),
                      prefixIcon: Icon(Icons.search, color: _accentYellow),
                      filled: true,
                      fillColor: _secondaryBlack,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value.toLowerCase());
                    },
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list, color: _accentYellow),
                  onSelected: (value) {
                    setState(() => _filterStatus = value);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'all',
                      child: Text('All Messages'),
                    ),
                    const PopupMenuItem(
                      value: 'pending',
                      child: Text('Pending'),
                    ),
                    const PopupMenuItem(value: 'read', child: Text('Read')),
                    const PopupMenuItem(
                      value: 'resolved',
                      child: Text('Resolved'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('contact_messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: _accentYellow),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No messages found',
                      style: TextStyle(color: _hintColor),
                    ),
                  );
                }

                final messages = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final matchesStatus =
                      _filterStatus == 'all' || data['status'] == _filterStatus;
                  final matchesSearch =
                      _searchQuery.isEmpty ||
                      (data['subject'] as String).toLowerCase().contains(
                        _searchQuery,
                      ) ||
                      (data['message'] as String).toLowerCase().contains(
                        _searchQuery,
                      ) ||
                      (data['email'] as String).toLowerCase().contains(
                        _searchQuery,
                      );
                  return matchesStatus && matchesSearch;
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final doc = messages[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final createdAt = data['createdAt'] as Timestamp?;
                    final status = data['status'] as String? ?? 'pending';

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _secondaryBlack,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ExpansionTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['subject'] ?? 'No Subject',
                              style: TextStyle(
                                color: _white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  color: _accentYellow,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  data['email'] ?? 'No email',
                                  style: TextStyle(
                                    color: _hintColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  status.toUpperCase(),
                                  style: TextStyle(
                                    color: _white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (createdAt != null)
                                Text(
                                  DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(createdAt.toDate()),
                                  style: TextStyle(
                                    color: _hintColor,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['message'] ?? 'No message content',
                                  style: TextStyle(color: _white),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (status != 'read')
                                      TextButton(
                                        onPressed: () => _updateMessageStatus(
                                          doc.id,
                                          'read',
                                        ),
                                        child: Text(
                                          'MARK AS READ',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    if (status != 'resolved')
                                      TextButton(
                                        onPressed: () => _updateMessageStatus(
                                          doc.id,
                                          'resolved',
                                        ),
                                        child: Text(
                                          'MARK AS RESOLVED',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    if (status == 'resolved')
                                      TextButton(
                                        onPressed: () => _updateMessageStatus(
                                          doc.id,
                                          'pending',
                                        ),
                                        child: Text(
                                          'REOPEN',
                                          style: TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                    TextButton(
                                      onPressed: () => _sendAdminReply(
                                        doc.id,
                                        data['email'],
                                      ),
                                      child: Text(
                                        'REPLY',
                                        style: TextStyle(color: _accentYellow),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => _deleteMessage(doc.id),
                                      child: const Text(
                                        'DELETE',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
