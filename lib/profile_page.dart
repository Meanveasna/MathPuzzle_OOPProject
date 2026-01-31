import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'player_storage.dart';
import 'core/app_theme.dart';

import 'l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  final String username;

  ProfilePage({required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

final TextEditingController _usernameController = TextEditingController();
bool _isEditingName = false;

class _ProfilePageState extends State<ProfilePage> {
  User? _currentUser;
  bool _isLoading = true;
  String _selectedAvatarId = '0';

  final List<String> _avatars = [
    '🐼',
    '🦊',
    '🦁',
    '🐯',
    '🐸',
    '🐨',
    '🦄',
    '🐲',
    '👾',
    '🤖',
    '👻',
    '👽',
    '⚽',
    '🏀',
    '🎸',
    '🎨',
    '🚀',
    '⭐',
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
        if (!_avatars.contains(_selectedAvatarId) && _selectedAvatarId != '0') {
          int? idx = int.tryParse(_selectedAvatarId);
          if (idx != null && idx >= 0 && idx < _avatars.length) {
            _selectedAvatarId = _avatars[idx];
          } else {
            if (!_avatars.contains(_selectedAvatarId))
              _selectedAvatarId = _avatars[0];
          }
        }
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;
    if (_currentUser != null) {
      _currentUser!.avatarId = _selectedAvatarId;
      await PlayerRepository().updateUser(_currentUser!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileSaved),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.profile),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Current Avatar Display
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Text(
                _selectedAvatarId.isNotEmpty ? _selectedAvatarId : '🐼',
                style: TextStyle(fontSize: 60),
              ),
            ),
            SizedBox(height: 5),

            // Username with Edit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _currentUser?.username ?? widget.username,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blueGrey),
                  tooltip: l10n.editUsername,
                  onPressed: _showEditNameDialog,
                ),
              ],
            ),

            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber),
              ),
              child: Text(
                '${l10n.totalScore}: ${_currentUser?.totalScore ?? 0}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            ),

            SizedBox(height: 15),
            Text(
              l10n.chooseAvatar,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),

            // Avatar Selector Grid
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
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
                        color: isSelected
                            ? AppTheme.primaryColor.withOpacity(0.3)
                            : Colors.grey[100],
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: AppTheme.primaryColor, width: 3)
                            : null,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                onPressed: _saveProfile,
                child: Text(
                  l10n.saveChanges,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNameDialog() {
    final l10n = AppLocalizations.of(context)!;
    _usernameController.text = _currentUser?.username ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.editUsername),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(hintText: l10n.enterUsername),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                _updateUsername(_usernameController.text.trim());
                Navigator.pop(context);
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }

  void _updateUsername(String newName) async {
    if (newName.isNotEmpty && _currentUser != null) {
      setState(() {
        _currentUser!.username = newName;
      });
      await PlayerRepository().updateUser(_currentUser!);
    }
  }
}
