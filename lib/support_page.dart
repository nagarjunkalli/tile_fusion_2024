
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart'; // Import main.dart to access GameTheme

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Could not launch the URL
      // TODO: Show proper error dialog to user instead of print
      // print('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine button style based on the current theme
    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final GameTheme gameTheme = Theme.of(context).brightness == Brightness.dark
        ? GameTheme.dark // Assuming you have GameTheme.dark defined
        : GameTheme.light; // Assuming you have GameTheme.light defined


    return Scaffold(
      backgroundColor: gameTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Support Me',
          style: TextStyle(color: gameTheme.titleColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: gameTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: gameTheme.titleColor),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  // Replace with your actual Buy Me a Coffee URL
                  _launchURL('https://www.buymeacoffee.com/nagarjunkalli');
                },
                child: const Text('Buy Me a Coffee'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  // Replace with your actual Patreon URL
                  _launchURL('https://www.patreon.com/nagarjunkalli');
                },
                child: const Text('Support on Patreon'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

