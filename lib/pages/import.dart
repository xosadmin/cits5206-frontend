import 'package:flutter/material.dart';

class ImportPage extends StatelessWidget {
  const ImportPage({super.key});

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
            ),
            const SizedBox(height: 12),
            _buildImportButton(
              label: 'Import from Apple Podcasts',
              backgroundColor: const Color(0xFFF9F4FF),
              borderColor: const Color(0xFF986FC3),
              icon: Image.asset('assets/icons/applemusic.png'),
            ),
            const SizedBox(height: 12),
            _buildImportButton(
              label: 'Import from Youtube Music',
              backgroundColor: const Color(0xFFFFE9E9),
              borderColor: const Color(0xFFFF0000),
              icon: Image.asset('assets/icons/youtube.png'),
            ),
            const SizedBox(height: 450),
            SizedBox(
              width: 327,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // 跳转逻辑
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00008B), // 蓝色背景
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
  }) {
    return SizedBox(
      width: 327,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          // 点击逻辑
        },
        icon: icon, // 图标颜色与边框一致
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
