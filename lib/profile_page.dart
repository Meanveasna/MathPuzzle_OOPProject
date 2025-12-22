import 'dart:io';
import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'player_storage.dart';
import 'core/app_theme.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  ProfilePage({required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _imagePathController;
  String _gender = 'Male';
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _imagePathController = TextEditingController();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = await PlayerRepository().getUser(widget.username);
    if (user != null) {
      setState(() {
        _currentUser = user;
        _emailController.text = user.email;
        _phoneController.text = user.phoneNumber;
        _imagePathController.text = user.profileImagePath;
        if (user.gender.isNotEmpty) _gender = user.gender;
        _isLoading = false;
      });
    } else {
       // Should default create user if not found, but logic implies they are logged in
       setState(() { _isLoading = false; });
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      User updatedUser = User(
        username: widget.username,
        email: _emailController.text,
        gender: _gender,
        phoneNumber: _phoneController.text,
        profileImagePath: _imagePathController.text,
      );

      await PlayerRepository().updateUser(updatedUser);

      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Saved!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Go back to menu
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(backgroundColor: AppTheme.backgroundColor, body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Placeholder
              GestureDetector(
                onTap: () {
                   // In future: Open file picker
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Enter file path below')));
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                  // Use FileImage for local files (Offline mode)
                  backgroundImage: _imagePathController.text.isNotEmpty 
                      ? FileImage(File(_imagePathController.text)) as ImageProvider
                      : null,
                  onBackgroundImageError: (_, __) {
                     // Fallback silently if file not found
                  },
                  child: _imagePathController.text.isEmpty 
                      ? Text('📷', style: TextStyle(fontSize: 50))
                      : null,
                ),
              ),
              SizedBox(height: 30),
              
              TextFormField(
                initialValue: widget.username,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person)),
              ),
              SizedBox(height: 20),
              
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
                validator: (val) => val!.contains('@') ? null : 'Enter valid email',
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
              ),
               SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.people)),
                items: ['Male', 'Female', 'Other'].map((String val) {
                  return DropdownMenuItem(value: val, child: Text(val));
                }).toList(),
                onChanged: (val) => setState(() => _gender = val!),
              ),
              SizedBox(height: 20),
              
              TextFormField(
                controller: _imagePathController,
                decoration: InputDecoration(
                  labelText: 'Profile Image URL/Path', 
                  prefixIcon: Icon(Icons.image),
                  helperText: 'Paste a URL or local path'
                ),
                onChanged: (val) => setState(() {}),
              ),
              SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('SAVE PROFILE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
