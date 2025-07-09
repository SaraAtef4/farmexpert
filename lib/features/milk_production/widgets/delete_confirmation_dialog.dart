import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showDeleteConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Delete",
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
            ),
            SizedBox(height: 10),
            Text(
                "Do you really want to delete this record? This process cannot be undone."
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      onConfirm(); // بس كده، من غير pop
                    },
                    child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(.2),
                        ),
                        child: Center(
                          child: Text(
                            "No, Keep it.",
                            style: GoogleFonts.inter(color: Colors.black),
                          ),
                        )
                    )
                ),
                TextButton(
                    onPressed: () {
                      onConfirm();
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.pink,
                        ),
                        child: Center(
                          child: Text(
                            "Yes, Delete!",
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                        )
                    )
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
