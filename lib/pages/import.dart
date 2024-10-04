import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audiopin_frontend/api_service.dart';
import 'package:audiopin_frontend/pages/subscriptions.dart';

class ImportPage extends StatefulWidget {
  const ImportPage({super.key});

  @override
  _ImportPageState createState() => _ImportPageState();
}

class _ImportPageState extends State<ImportPage> {
  String? userID;

  @override
  void initState() {
    super.initState();
    _getUserID(); // Fetch userID on page initialization
  }

  Future<void> _getUserID() async {
    String? id = await UserService.getUserID();
    setState(() {
      userID = id;
      print(
          'Retrieved userID: $userID'); // Confirm that userID is fetched correctly
    });
  }

  Future<void> _importOPML(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xml', 'opml'], // Allow XML or OPML files
      withData: true,
    );

    if (result != null) {
      String opmlContent = String.fromCharCodes(result.files.single.bytes!);

      // Ensure userID exists
      if (userID == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User not authenticated. Please log in.')),
        );
        return;
      }

      try {
        // Call the API to upload and parse OPML
        List<Map<String, String>> podcasts =
            await ApiService.uploadAndParseOPML(opmlContent);

        // Navigate to Subscriptions page with the parsed podcasts
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImportSubscriptionsPage(podcasts: podcasts),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to import OPML: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Import your subscriptions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 34),
            _buildImportButton(
              label: 'Import from Spotify',
              backgroundColor: const Color(0xFFEAFEF1),
              borderColor: const Color(0xFF1ED660),
              icon: Image.asset('assets/icons/spotify.png'),
              context: context,
            ),
            const SizedBox(height: 12),
            _buildImportButton(
              label: 'Import from Apple Podcasts',
              backgroundColor: const Color(0xFFF9F4FF),
              borderColor: const Color(0xFF986FC3),
              icon: Image.asset('assets/icons/applemusic.png'),
              context: context,
            ),
            const SizedBox(height: 12),
            _buildImportButton(
              label: 'Import from Youtube Music',
              backgroundColor: const Color(0xFFFFE9E9),
              borderColor: const Color(0xFFFF0000),
              icon: Image.asset('assets/icons/youtube.png'),
              context: context,
            ),
            const SizedBox(height: 450),
            SizedBox(
              width: 327,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/interests');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00008B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
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

  Widget _buildImportButton({
    required String label,
    required Color backgroundColor,
    required Color borderColor,
    required Widget icon,
    required BuildContext context,
  }) {
    return SizedBox(
      width: 327,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          _importOPML(context); // Trigger import operation on button click
        },
        icon: icon,
        label: Text(
          label,
          style: const TextStyle(color: Color(0xFF41414E)),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(color: borderColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }
}
