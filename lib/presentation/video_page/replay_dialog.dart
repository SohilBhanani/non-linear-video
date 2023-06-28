import 'package:flutter/material.dart';

class ReplayDialog extends StatelessWidget {
  const ReplayDialog({super.key, required this.onAgreed});
  final VoidCallback onAgreed;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const Text(
            "Replay video reel ? ",
            style: TextStyle(fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: onAgreed, child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text("No"))
            ],
          )
        ],
      ),
    );
  }
}
