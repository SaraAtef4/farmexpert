
import 'package:flutter/material.dart';

class FarmStaffCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final Color color;
  final VoidCallback? onTap;

  const FarmStaffCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.color,
    this.onTap,
  });

  @override
  State<FarmStaffCard> createState() => _FarmStaffCardState();
}

class _FarmStaffCardState extends State<FarmStaffCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: Transform.scale(
        scale: _isPressed ? 0.98 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(15),
            boxShadow: _isPressed
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              )
            ]
                : [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.imagePath,
                height: 80,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error, size: 80, color: Colors.red),
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}