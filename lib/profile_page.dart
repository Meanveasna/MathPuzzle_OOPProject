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
  User? _currentUser;
  bool _isLoading = true;
  String _selectedAvatarId = '0';

  // Predefined Avatars (Emojis)
  final List<String> _avatars = [
    '🐼', '🦊', '🦁', '🐯', '🐸', '🐨', 
    '🦄', '🐲', '👾', '🤖', '👻', '👽',
    '⚽', '🏀', '🎸', '🎨', '🚀', '⭐'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    User? user = await PlayerRepository().getUser();
    if (user != null) {
       setState(() {
         _currentUser = user;
         _selectedAvatarId = user.avatarId;
         // Ensure valid avatar
         if (!_avatars.contains(_selectedAvatarId) && _selectedAvatarId != '0') {
           // If it's a file path or unknown, default to first or keep if we supported custom images
           // For this "Kahoot style", we force emoji. If it was a path, we reset.
           // However, let's try to parse if it's an int index just in case.
           int? idx = int.tryParse(_selectedAvatarId);
           if (idx != null && idx >= 0 && idx < _avatars.length) {
              _selectedAvatarId = _avatars[idx];
           } else {
             // Default
             if (!_avatars.contains(_selectedAvatarId)) _selectedAvatarId = _avatars[0];
           }
         }
         _isLoading = false;
       });
    } else {
       setState(() { _isLoading = false; });
    }
  }

  void _saveProfile() async {
    if (_currentUser != null) {
      _currentUser!.avatarId = _selectedAvatarId;
      await PlayerRepository().updateUser(_currentUser!);

      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Saved!'), backgroundColor: Colors.green),
        );
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
      appBar: AppBar(title: Text('My Profile'), backgroundColor: AppTheme.primaryColor),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Current Avatar Display
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Text(
                _selectedAvatarId.isNotEmpty ? _selectedAvatarId : '😊',
                style: TextStyle(fontSize: 60),
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.username,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber),
              ),
              child: Text(
                'Total Score: ${_currentUser?.totalScore ?? 0}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown),
              ),
            ),
            
            SizedBox(height: 40),
            Text("Choose Your Avatar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700])),
            SizedBox(height: 15),
            
            // Avatar Selector Grid
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]
              ),
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _avatars.length,
                itemBuilder: (context, index) {
                  final avatar = _avatars[index];
                  bool isSelected = avatar == _selectedAvatarId;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatarId = avatar;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor.withOpacity(0.3) : Colors.grey[100],
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: AppTheme.primaryColor, width: 3) : null,
                      ),
                      child: Center(
                        child: Text(avatar, style: TextStyle(fontSize: 24)),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                onPressed: _saveProfile,
                child: Text('SAVE CHANGES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
