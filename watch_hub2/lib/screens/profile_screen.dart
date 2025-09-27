// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   bool _isEditing = false;
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _phoneController;
//   late TextEditingController _addressController;
//   late TextEditingController _cityController;
//   late TextEditingController _postalCodeController;
//   late TextEditingController _emailController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//     _phoneController = TextEditingController();
//     _addressController = TextEditingController();
//     _cityController = TextEditingController();
//     _postalCodeController = TextEditingController();
//     _emailController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _cityController.dispose();
//     _postalCodeController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     setState(() => _isEditing = false);

//     try {
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
//         'name': _nameController.text.trim(),
//         'phone': _phoneController.text.trim(),
//         'address': _addressController.text.trim(),
//         'city': _cityController.text.trim(),
//         'postalCode': _postalCodeController.text.trim(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Profile updated successfully'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to update profile: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       setState(() => _isEditing = true);
//     }
//   }

//   Widget _buildProfileHeader(User user, Map<String, dynamic> userData) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 50,
//           backgroundColor: Colors.grey[200],
//           child: Icon(
//             Icons.person,
//             size: 50,
//             color: Colors.grey[600],
//           ),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           _nameController.text.isNotEmpty 
//               ? _nameController.text 
//               : 'Your Name',
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           user.email ?? 'No email',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey[600],
//           ),
//         ),
//         const SizedBox(height: 24),
//       ],
//     );
//   }

//   Widget _buildEditButton() {
//     return FloatingActionButton(
//       onPressed: () => setState(() => _isEditing = true),
//       backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//       child: const Icon(Icons.edit, color: Colors.white),
//     );
//   }

//  Widget _buildActionButtons() {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//     child: Row(
//       children: [
//         Expanded(
//           child: OutlinedButton(
//             style: OutlinedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               side: const BorderSide(color: Color.fromARGB(255, 4, 66, 85)),
//             ),
//             onPressed: () => setState(() => _isEditing = false),
//             child: const Text(
//               'CANCEL',
//               style: TextStyle(color: Color.fromARGB(255, 4, 66, 85)),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//             ),
//             onPressed: _saveProfile,
//             child: const Text('SAVE'),
//           ),
//         ),
//       ],
//     ),
//   );
// }

//  Widget _buildDetailCard(String title, List<Widget> children) {
//   return Card(
//     elevation: 2,
//     margin: const EdgeInsets.symmetric(vertical: 8),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color.fromARGB(255, 4, 66, 85),
//             ), // ✅ fixed here
//           ),
//           const SizedBox(height: 12),
//           ...children,
//         ],
//       ),
//     ),
//   );
// }


//   Widget _buildReadOnlyField(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const Divider(height: 24),
//         ],
//       ),
//     );
//   }

//   Widget _buildEditableField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     TextInputType keyboardType = TextInputType.text,
//     bool enabled = true,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         enabled: enabled,
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           prefixIcon: Icon(icon, color: const Color.fromARGB(255, 4, 66, 85)),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: Colors.grey),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: const BorderSide(color: Color.fromARGB(255, 4, 66, 85)),
//           ),
//         ),
//         keyboardType: keyboardType,
//         validator: (value) {
//           if (value == null || value.isEmpty) return 'Please enter $label';
//           if (label.contains('Email') && !value.contains('@')) {
//             return 'Enter a valid email';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Profile'),
//         backgroundColor: const Color.fromARGB(255, 4, 66, 85),
//         elevation: 0,
//       ),
//       floatingActionButton: !_isEditing ? _buildEditButton() : null,
//       body: user == null
//           ? const Center(child: Text('Please login to view your profile'))
//           : StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('users')
//                   .doc(user.uid)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.hasData || !snapshot.data!.exists) {
//                   return const Center(child: Text('User data not found'));
//                 }

//                 final userData = snapshot.data!.data() as Map<String, dynamic>;

//                 // Initialize controllers with current values
//                 _nameController.text = userData['name'] ?? '';
//                 _phoneController.text = userData['phone'] ?? '';
//                 _addressController.text = userData['address'] ?? '';
//                 _cityController.text = userData['city'] ?? '';
//                 _postalCodeController.text = userData['postalCode'] ?? '';
//                 _emailController.text = user.email ?? '';

//                 final createdAt = userData['createdAt'] as Timestamp?;
//                 final updatedAt = userData['updatedAt'] as Timestamp?;

//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         _buildProfileHeader(user, userData),

//                         // Personal Information
//                         _buildDetailCard(
//                           'Personal Information',
//                           [
//                             if (!_isEditing) ...[
//                               _buildReadOnlyField('Name', _nameController.text.isNotEmpty ? _nameController.text : 'Not provided'),
//                               _buildReadOnlyField('Email', _emailController.text),
//                               _buildReadOnlyField('Phone', _phoneController.text.isNotEmpty ? _phoneController.text : 'Not provided'),
//                             ] else ...[
//                               _buildEditableField(
//                                 controller: _nameController,
//                                 label: 'Full Name',
//                                 hint: 'Enter your full name',
//                                 icon: Icons.person,
//                               ),
//                               _buildEditableField(
//                                 controller: _emailController,
//                                 label: 'Email',
//                                 hint: 'Enter your email',
//                                 icon: Icons.email,
//                                 keyboardType: TextInputType.emailAddress,
//                                 enabled: false, // Email shouldn't be editable
//                               ),
//                               _buildEditableField(
//                                 controller: _phoneController,
//                                 label: 'Phone Number',
//                                 hint: 'Enter your phone number',
//                                 icon: Icons.phone,
//                                 keyboardType: TextInputType.phone,
//                               ),
//                             ],
//                           ],
//                         ),

//                         // Shipping Address
//                         _buildDetailCard(
//                           'Shipping Address',
//                           [
//                             if (!_isEditing) ...[
//                               _buildReadOnlyField('Address', _addressController.text.isNotEmpty ? _addressController.text : 'Not provided'),
//                               _buildReadOnlyField('City', _cityController.text.isNotEmpty ? _cityController.text : 'Not provided'),
//                               _buildReadOnlyField('Postal Code', _postalCodeController.text.isNotEmpty ? _postalCodeController.text : 'Not provided'),
//                             ] else ...[
//                               _buildEditableField(
//                                 controller: _addressController,
//                                 label: 'Street Address',
//                                 hint: 'Enter your street address',
//                                 icon: Icons.home,
//                               ),
//                               _buildEditableField(
//                                 controller: _cityController,
//                                 label: 'City',
//                                 hint: 'Enter your city',
//                                 icon: Icons.location_city,
//                               ),
//                               _buildEditableField(
//                                 controller: _postalCodeController,
//                                 label: 'Postal Code',
//                                 hint: 'Enter your postal code',
//                                 icon: Icons.local_shipping,
//                               ),
//                             ],
//                           ],
//                         ),

//                         // Account Information
//                         _buildDetailCard(
//                           'Account Information',
//                           [
//                             _buildReadOnlyField(
//                               'Member Since',
//                               createdAt != null
//                                   ? DateFormat('MMM dd, yyyy').format(createdAt.toDate())
//                                   : 'Unknown',
//                             ),
//                             if (updatedAt != null)
//                               _buildReadOnlyField(
//                                 'Last Updated',
//                                 DateFormat('MMM dd, yyyy').format(updatedAt.toDate()),
//                               ),
//                           ],
//                         ),

//                         if (_isEditing) ...[
//                           const SizedBox(height: 24),
//                           _buildActionButtons(),
//                           const SizedBox(height: 24),
//                         ],
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _emailController;

  // Black, Yellow & White Theme
  final Color _primaryBlack = const Color(0xFF121212);
  final Color _secondaryBlack = const Color(0xFF1E1E1E);
  final Color _accentYellow = const Color(0xFFFFD700);
  final Color _white = const Color(0xFFFFFFFF);
  final Color _dividerColor = const Color(0xFF2D2D2D);
  final Color _hintColor = const Color(0xFFA0A0A0);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _postalCodeController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _isEditing = false);

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'postalCode': _postalCodeController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated successfully'),
          backgroundColor: _accentYellow,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: ${e.toString()}'),
          backgroundColor: Colors.red[400],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      setState(() => _isEditing = true);
    }
  }

  Widget _buildProfileHeader(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MY PROFILE',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _white,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _nameController.text.isNotEmpty ? _nameController.text : 'Your Name',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _accentYellow,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email ?? 'No email',
          style: TextStyle(
            fontSize: 14,
            color: _hintColor,
          ),
        ),
        const SizedBox(height: 16),
        Divider(color: _dividerColor, thickness: 1),
      ],
    );
  }

  Widget _buildEditButton() {
    return FloatingActionButton(
      onPressed: () => setState(() => _isEditing = true),
      backgroundColor: _accentYellow,
      elevation: 4,
      child: Icon(Icons.edit, color: _primaryBlack),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: _accentYellow),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => setState(() => _isEditing = false),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: _accentYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: _accentYellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _saveProfile,
              child: Text(
                'SAVE',
                style: TextStyle(
                  color: _primaryBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _secondaryBlack,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _accentYellow,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: _hintColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: _white,
            ),
          ),
          Divider(height: 24, color: _dividerColor),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: _hintColor,
            ),
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            enabled: enabled,
            style: TextStyle(color: _white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: _hintColor),
              prefixIcon: Icon(icon, color: _accentYellow),
              filled: true,
              fillColor: _primaryBlack,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _accentYellow, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
            ),
            keyboardType: keyboardType,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter $label';
              if (label.contains('Email') && !value.contains('@')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: _primaryBlack,
      appBar: AppBar(
        title: const Text('Profile',
      style: TextStyle(color: Colors.white), 
    ),
        backgroundColor: _primaryBlack,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: _accentYellow),
      ),
      floatingActionButton: !_isEditing ? _buildEditButton() : null,
      body: user == null
          ? Center(
              child: Text(
                'Please login to view your profile',
                style: TextStyle(color: _hintColor),
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: _accentYellow),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                    child: Text(
                      'User data not found',
                      style: TextStyle(color: _hintColor),
                    ),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;

                // Initialize controllers with current values
                _nameController.text = userData['name'] ?? '';
                _phoneController.text = userData['phone'] ?? '';
                _addressController.text = userData['address'] ?? '';
                _cityController.text = userData['city'] ?? '';
                _postalCodeController.text = userData['postalCode'] ?? '';
                _emailController.text = user.email ?? '';

                final createdAt = userData['createdAt'] as Timestamp?;
                final updatedAt = userData['updatedAt'] as Timestamp?;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildProfileHeader(user),
                        const SizedBox(height: 16),

                        // Personal Information
                        _buildDetailCard(
                          'PERSONAL INFORMATION',
                          [
                            if (!_isEditing) ...[
                              _buildReadOnlyField('Name', _nameController.text.isNotEmpty ? _nameController.text : 'Not provided'),
                              _buildReadOnlyField('Email', _emailController.text),
                              _buildReadOnlyField('Phone', _phoneController.text.isNotEmpty ? _phoneController.text : 'Not provided'),
                            ] else ...[
                              _buildEditableField(
                                controller: _nameController,
                                label: 'Full Name',
                                hint: 'Enter your full name',
                                icon: Icons.person,
                              ),
                              _buildEditableField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'Enter your email',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                enabled: false,
                              ),
                              _buildEditableField(
                                controller: _phoneController,
                                label: 'Phone Number',
                                hint: 'Enter your phone number',
                                icon: Icons.phone,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ],
                        ),

                        // Shipping Address
                        _buildDetailCard(
                          'SHIPPING ADDRESS',
                          [
                            if (!_isEditing) ...[
                              _buildReadOnlyField('Address', _addressController.text.isNotEmpty ? _addressController.text : 'Not provided'),
                              _buildReadOnlyField('City', _cityController.text.isNotEmpty ? _cityController.text : 'Not provided'),
                              _buildReadOnlyField('Postal Code', _postalCodeController.text.isNotEmpty ? _postalCodeController.text : 'Not provided'),
                            ] else ...[
                              _buildEditableField(
                                controller: _addressController,
                                label: 'Street Address',
                                hint: 'Enter your street address',
                                icon: Icons.home,
                              ),
                              _buildEditableField(
                                controller: _cityController,
                                label: 'City',
                                hint: 'Enter your city',
                                icon: Icons.location_city,
                              ),
                              _buildEditableField(
                                controller: _postalCodeController,
                                label: 'Postal Code',
                                hint: 'Enter your postal code',
                                icon: Icons.local_shipping,
                              ),
                            ],
                          ],
                        ),

                        // Account Information
                        _buildDetailCard(
                          'ACCOUNT INFORMATION',
                          [
                            _buildReadOnlyField(
                              'Member Since',
                              createdAt != null
                                  ? DateFormat('MMM dd, yyyy').format(createdAt.toDate())
                                  : 'Unknown',
                            ),
                            if (updatedAt != null)
                              _buildReadOnlyField(
                                'Last Updated',
                                DateFormat('MMM dd, yyyy').format(updatedAt.toDate()),
                              ),
                          ],
                        ),

                        if (_isEditing) ...[
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}