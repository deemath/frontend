import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/auth_provider.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title:
                const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to settings page
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.white),
            title: const Text('Privacy', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to privacy page
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.white),
            title: const Text('Help', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to help page
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: const Text('About', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to about page
            },
          ),
          const Divider(color: Colors.white54),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              
            },
          ),
        ],
      ),
    );
  }
}
