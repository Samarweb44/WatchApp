// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Subscribers extends StatefulWidget {
//   const Subscribers({super.key});

//   @override
//   State<Subscribers> createState() => _SubscribersState();
// }

// class _SubscribersState extends State<Subscribers> {
//   List<Map<String, dynamic>> _subscribers = [];
//   List<Map<String, dynamic>> _filteredSubscribers = [];
//   TextEditingController searchController = TextEditingController();
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchSubscribers();
//   }

//   void fetchSubscribers() async {
//     final userdata = await FirebaseFirestore.instance.collection('subscribers').get();
//     final rawdata = userdata.docs.map((doc) {
//       var data = doc.data();
//       data['id'] = doc.id;

//       if (data['timestamp'] is Timestamp) {
//         data['timestamp'] = (data['timestamp'] as Timestamp).toDate();
//       }

//       return data;
//     }).toList();

//     setState(() {
//       _subscribers = rawdata;
//       _filteredSubscribers = rawdata;
//       isLoading = false;
//     });
//   }

//   void deleteSubscriber(String docId) async {
//     try {
//       await FirebaseFirestore.instance.collection('subscribers').doc(docId).delete();
//       fetchSubscribers();
//     } catch (e) {
//       print("Error deleting subscriber: $e");
//     }
//   }

//   void deleteDialog(String docId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Delete Confirmation', style: TextStyle(color: Colors.black)),
//           content: const Text('Are you sure you want to delete this subscriber?', style: TextStyle(color: Colors.black)),
//           actions: [
//             ElevatedButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('Cancel', style: TextStyle(color: Colors.black)),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 deleteSubscriber(docId);
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Delete', style: TextStyle(color: Colors.black)),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void searchSubscribers(String query) {
//     final results = _subscribers.where((subscriber) {
//       final email = subscriber['email']?.toLowerCase() ?? "";
//       return email.contains(query.toLowerCase());
//     }).toList();

//     setState(() {
//       _filteredSubscribers = results;
//     });
//   }

//   void sendEmail(String recipientEmail) async {
//     final Uri emailUri = Uri.parse(
//         'https://mail.google.com/mail/?view=cm&fs=1&to=$recipientEmail&su=Exclusive%20Offer%20for%20You&body=Hello!%20Check%20out%20our%20new%20collection%20and%20discounts!');

//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri, mode: LaunchMode.externalApplication);
//     } else {
//       print("Could not launch Gmail");
//     }
//   }

//   void sendEmailToAllSubscribers() async {
//     final allEmails = _subscribers.map((sub) => sub['email']).join(",");
//     final Uri emailUri = Uri.parse(
//         'https://mail.google.com/mail/?view=cm&fs=1&to=$allEmails&su=Exciting%20News%20for%20Our%20Subscribers!&body=Hello%20Everyone!%20We%20have%20a%20special%20announcement%20for%20you!');

//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri, mode: LaunchMode.externalApplication);
//     } else {
//       print("Could not launch Gmail");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Subscribers'),
//          backgroundColor:const Color.fromARGB(255, 4, 66, 85), // Dark blue background
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.email),
//             onPressed: sendEmailToAllSubscribers,
//             tooltip: 'All Subscribers Mail',
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           :
          
//            Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     controller: searchController,
//                     decoration: const InputDecoration(
//                       labelText: 'Search Subscribers by Email',
//                       labelStyle: TextStyle(color: Colors.black),
//                       prefixIcon: Icon(Icons.search, color: Colors.black),
//                     ),
//                     style: const TextStyle(color: Colors.black),
//                     onChanged: (value) {
//                       setState(() {
//                         _filteredSubscribers = value.isEmpty
//                             ? _subscribers
//                             : _subscribers.where((subscriber) {
//                                 return subscriber['email']?.toLowerCase().contains(value.toLowerCase()) ?? false;
//                               }).toList();
//                       });
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _filteredSubscribers.length,
//                     itemBuilder: (context, index) {
//                       final subscriber = _filteredSubscribers[index];
//                       final email = subscriber["email"] ?? 'No email';

//                       return Card(
//                         margin: const EdgeInsets.all(10),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                         elevation: 5,
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text("Email: $email", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
//                               Text(
//                                 "Timestamp: ${subscriber["timestamp"] != null ? DateFormat('yyyy-MM-dd HH:mm').format(subscriber["timestamp"]) : 'No timestamp available'}",
//                                 style: const TextStyle(color: Colors.black),
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.email, color: Colors.blue),
//                                     onPressed: () => sendEmail(email),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete, color: Colors.red),
//                                     onPressed: () => deleteDialog(subscriber["id"]),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Define the color palette for consistency
class AppColors {
  static const Color primaryBlack = Color(0xFF1A1A1A); // Dark charcoal/black
  static const Color accentYellow = Color(0xFFFFD166); // Muted yellow
  static const Color backgroundWhite = Color(0xFFFFFFFF); // Pure white
  static const Color cardBackground = Color(0xFFF5F5F5); // Light grey for card backgrounds
  static const Color textLightGrey = Color(0xFF616161); // For secondary text
  static const Color borderGrey = Color(0xFFE0E0E0); // Light grey for borders
}

class Subscribers extends StatefulWidget {
  const Subscribers({super.key});

  @override
  State<Subscribers> createState() => _SubscribersState();
}

class _SubscribersState extends State<Subscribers> {
  List<Map<String, dynamic>> _subscribers = [];
  List<Map<String, dynamic>> _filteredSubscribers = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSubscribers();
  }

  Future<void> fetchSubscribers() async {
    try {
      final userdata = await FirebaseFirestore.instance.collection('subscribers').get();
      final rawdata = userdata.docs.map((doc) {
        var data = doc.data();
        data['id'] = doc.id;

        if (data['timestamp'] is Timestamp) {
          data['timestamp'] = (data['timestamp'] as Timestamp).toDate();
        }
        return data;
      }).toList();

      setState(() {
        _subscribers = rawdata;
        _filteredSubscribers = rawdata;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching subscribers: $e");
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load subscribers: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> deleteSubscriber(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('subscribers').doc(docId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subscriber deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      fetchSubscribers(); // Refresh the list
    } catch (e) {
      debugPrint("Error deleting subscriber: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete subscriber: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmationDialog(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: AppColors.backgroundWhite,
          title: const Text(
            'Delete Subscriber',
            style: TextStyle(color: AppColors.primaryBlack, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this subscriber? This action cannot be undone.',
            style: TextStyle(color: AppColors.textLightGrey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: AppColors.primaryBlack),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                deleteSubscriber(docId); // Perform deletion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700, // Red delete button
                foregroundColor: AppColors.backgroundWhite,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'DELETE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendEmail(String recipientEmail) async {
    final Uri emailUri = Uri.parse(
        'https://mail.google.com/mail/?view=cm&fs=1&to=$recipientEmail&su=Exclusive%20Offer%20for%20You&body=Hello!%20Check%20out%20our%20new%20collection%20and%20discounts!');

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch Gmail for $recipientEmail");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open email client.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> sendEmailToAllSubscribers() async {
    if (_subscribers.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No subscribers to send email to.'),
            backgroundColor: AppColors.accentYellow,
          ),
        );
      }
      return;
    }

    final allEmails = _subscribers.map((sub) => sub['email']).where((email) => email != null).join(",");

    if (allEmails.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No valid email addresses found among subscribers.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Gmail's 'to' field has a character limit, for a very large number of subscribers
    // it's better to use a dedicated email marketing service or a backend function.
    // For this example, we'll proceed assuming the list isn't excessively long.
    final Uri emailUri = Uri.parse(
        'https://mail.google.com/mail/?view=cm&fs=1&bcc=$allEmails&su=Exciting%20News%20for%20Our%20Subscribers!&body=Hello%20Everyone!%0A%0AWe%20have%20a%20special%20announcement%20and%20exclusive%20offers%20just%20for%20our%20valued%20subscribers!%0A%0AStay%20tuned%20for%20more%20updates!%0A%0ABest%20regards,%0AYour%20Team');

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch Gmail for all subscribers.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open email client to send to all subscribers.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subscribers',
          style: TextStyle(
            color: AppColors.backgroundWhite,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryBlack, // Black app bar
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.email, color: AppColors.accentYellow), // Yellow icon
            onPressed: sendEmailToAllSubscribers,
            tooltip: 'Email All Subscribers',
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.accentYellow,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by Email',
                      labelStyle: const TextStyle(color: AppColors.textLightGrey),
                      hintText: 'Enter email to search...',
                      hintStyle: const TextStyle(color: AppColors.textLightGrey),
                      prefixIcon: const Icon(Icons.search, color: AppColors.accentYellow), // Yellow search icon
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.borderGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.borderGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.accentYellow, width: 2), // Yellow focus border
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundWhite, // White background for search field
                      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    ),
                    style: const TextStyle(color: AppColors.primaryBlack, fontSize: 16),
                    onChanged: (value) {
                      setState(() {
                        _filteredSubscribers = value.isEmpty
                            ? _subscribers
                            : _subscribers.where((subscriber) {
                                return subscriber['email']?.toLowerCase().contains(value.toLowerCase()) ?? false;
                              }).toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _filteredSubscribers.isEmpty
                      ? const Center(
                          child: Text(
                            'No matching subscribers found.',
                            style: TextStyle(fontSize: 16, color: AppColors.textLightGrey),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          itemCount: _filteredSubscribers.length,
                          itemBuilder: (context, index) {
                            final subscriber = _filteredSubscribers[index];
                            final email = subscriber["email"] ?? 'No email';
                            final timestamp = subscriber["timestamp"] != null
                                ? DateFormat('MMM dd, yyyy - hh:mm a').format(subscriber["timestamp"])
                                : 'No timestamp available';

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 6, // Increased elevation
                              shadowColor: AppColors.primaryBlack.withOpacity(0.1), // Subtle shadow
                              color: AppColors.cardBackground, // Light grey card background
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      email,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryBlack,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Subscribed on: $timestamp",
                                      style: const TextStyle(color: AppColors.textLightGrey, fontSize: 13),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Tooltip(
                                          message: 'Send individual email',
                                          child: IconButton(
                                            icon: const Icon(Icons.email, color: AppColors.accentYellow, size: 28), // Yellow email icon
                                            onPressed: () => sendEmail(email),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Tooltip(
                                          message: 'Delete subscriber',
                                          child: IconButton(
                                            icon: Icon(Icons.delete_forever, color: Colors.red.shade700, size: 28), // Red delete icon
                                            onPressed: () => _showDeleteConfirmationDialog(subscriber["id"]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}