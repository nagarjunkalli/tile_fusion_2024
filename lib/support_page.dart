
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Could not launch the URL
      // Optionally, show an error message to the user
      print('Could not launch $urlString');
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
                  _launchURL('https://www.buymeacoffee.com/your_username');
                },
                child: const Text('Buy Me a Coffee'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  // Replace with your actual Patreon URL
                  _launchURL('https://www.patreon.com/your_username');
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

// You might need to make GameTheme and its properties accessible here.
// For simplicity, this example assumes GameTheme.dark and GameTheme.light are static or globally accessible.
// If GameTheme is part of your main.dart, you might need to pass theme data or colors.
// For now, I'll use a simplified GameTheme placeholder.
// You should have a more robust way to access your theme properties.

class GameTheme {
  final Color backgroundColor;
  final Color titleColor;
  // Add other theme properties if needed by SupportPage

  const GameTheme({
    required this.backgroundColor,
    required this.titleColor,
  });

  static GameTheme get light => const GameTheme(
        backgroundColor: Colors.white, // Example color
        titleColor: Colors.black, // Example color
      );

  static GameTheme get dark => const GameTheme(
        backgroundColor: Colors.black, // Example color
        titleColor: Colors.white, // Example color
      );
}

