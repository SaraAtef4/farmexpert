// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:intl/intl.dart';
// import 'dart:io';
//
// class VeterinarianCard extends StatefulWidget {
//   final Map<String, dynamic> vet;
//   final VoidCallback onDelete;
//   final VoidCallback onEdit;
//   final VoidCallback onImagePick;
//
//   const VeterinarianCard({
//     Key? key,
//     required this.vet,
//     required this.onDelete,
//     required this.onEdit,
//     required this.onImagePick,
//   }) : super(key: key);
//
//   @override
//   State<VeterinarianCard> createState() => _VeterinarianCardState();
// }
//
// class _VeterinarianCardState extends State<VeterinarianCard> {
//   bool _isExpanded = false;
//
//   String _formatDate(dynamic date) {
//     try {
//       if (date == null || date.toString().isEmpty) return 'Not set';
//       return DateFormat('yyyy-MM-dd').format(DateTime.parse(date.toString()));
//     } catch (e) {
//       return 'Invalid date';
//     }
//   }
//
//   String _formatNumber(dynamic value, [String suffix = '']) {
//     if (value == null) return '0$suffix';
//     return '${value.toString()}$suffix';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 GestureDetector(
//                   onTap: widget.onImagePick,
//                   child: CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.green.shade100,
//                     backgroundImage:
//                         widget.vet["image"] != null &&
//                                 File(widget.vet["image"]).existsSync()
//                             ? FileImage(File(widget.vet["image"]))
//                             : null,
//                     child:
//                         widget.vet["image"] == null
//                             ? const Icon(
//                               Icons.person,
//                               size: 30,
//                               color: Colors.green,
//                             )
//                             : null,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.vet["name"]?.toString() ??
//                             'Unnamed Veterinarian',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         widget.vet["specialty"]?.toString() ?? 'No specialty',
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Colors.black54,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 5),
//                       RatingBar.builder(
//                         initialRating:
//                             (widget.vet["rating"] as num?)?.toDouble() ?? 0.0,
//                         minRating: 1,
//                         direction: Axis.horizontal,
//                         allowHalfRating: true,
//                         itemCount: 5,
//                         itemSize: 20,
//                         itemBuilder:
//                             (context, _) =>
//                                 const Icon(Icons.star, color: Colors.amber),
//                         onRatingUpdate: (rating) {
//                           setState(() {
//                             widget.vet["rating"] = rating;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: widget.onEdit,
//                   icon: const Icon(Icons.edit, color: Colors.green),
//                 ),
//                 IconButton(
//                   onPressed: widget.onDelete,
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             InkWell(
//               onTap: () => setState(() => _isExpanded = !_isExpanded),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _isExpanded ? "Hide Details" : "Show Details",
//                     style: const TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Icon(
//                     _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//                     color: Colors.green,
//                   ),
//                 ],
//               ),
//             ),
//             if (_isExpanded) ...[
//               const SizedBox(height: 16),
//               _buildDetailRow(
//                 Icons.tag,
//                 widget.vet["code"] ?? 'Not assigned',
//               ),
//               _buildDetailRow(
//                 Icons.credit_card,
//                 widget.vet["nationalId"] ?? 'Not provided',
//               ),
//               _buildDetailRow(
//                 Icons.phone,
//                 widget.vet["phone"] ?? 'Not available',
//               ),
//               _buildDetailRow(
//                 Icons.cake,
//                 _formatNumber(widget.vet["age"], ' years'),
//               ),
//               _buildDetailRow(
//                 Icons.attach_money,
//                 _formatNumber(widget.vet["salary"], ' EGP'),
//               ),
//               _buildDetailRow(
//                 Icons.date_range,
//                 _formatDate(widget.vet["hireDate"]),
//               ),
//               _buildDetailRow(
//                 Icons.work_history,
//                 _formatNumber(widget.vet["experienceYears"], ' years'),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(IconData icon, String text) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.green, size: 24),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class VeterinarianCard extends StatefulWidget {
  final Map<String, dynamic> vet;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onImagePick;

  const VeterinarianCard({
    Key? key,
    required this.vet,
    required this.onDelete,
    required this.onEdit,
    required this.onImagePick,
  }) : super(key: key);

  @override
  State<VeterinarianCard> createState() => _VeterinarianCardState();
}

class _VeterinarianCardState extends State<VeterinarianCard> {
  bool _isExpanded = false;
  bool _showPassword = false;

  String _formatDate(dynamic date) {
    try {
      if (date == null || date.toString().isEmpty) return 'Not set';
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(date.toString()));
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _formatNumber(dynamic value, [String suffix = '']) {
    if (value == null) return '0$suffix';
    return '${value.toString()}$suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                // Profile Image
                GestureDetector(
                  onTap: widget.onImagePick,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green.shade100,
                    backgroundImage:
                    widget.vet["image"] != null &&
                        File(widget.vet["image"]).existsSync()
                        ? FileImage(File(widget.vet["image"]))
                        : null,
                    child:
                    widget.vet["image"] == null
                        ? const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.green,
                    )
                        : null,
                  ),
                ),

                const SizedBox(width: 16),

                // Name and Specialty
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.vet["name"]?.toString() ??
                            'Unnamed Veterinarian',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.vet["specialty"]?.toString() ?? 'No specialty',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      RatingBar.builder(
                        initialRating:
                        (widget.vet["rating"] as num?)?.toDouble() ?? 0.0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        itemBuilder:
                            (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) {
                          setState(() {
                            widget.vet["rating"] = rating;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.green,
                  onPressed: widget.onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: widget.onDelete,
                ),
              ],
            ),

            // Expand/Collapse Button
            const SizedBox(height: 10),
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? "Hide Details" : "Show Details",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            // Expanded Details
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              _buildDetailRow(Icons.tag, widget.vet["code"] ?? 'Not assigned'),
              _buildDetailRow(
                Icons.credit_card,
                widget.vet["nationalId"] ?? 'Not provided',
              ),
              _buildDetailRow(
                Icons.phone,
                widget.vet["phone"] ?? 'Not available',
              ),
              _buildDetailRow(
                Icons.email,
                widget.vet["email"] ?? 'Not provided',
              ),

              // Password Row with Toggle Visibility
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.lock, color: Colors.green, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _showPassword
                            ? widget.vet["password"] ?? 'Not set'
                            : '*******',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ],
                ),
              ),

              _buildDetailRow(
                Icons.cake,
                _formatNumber(widget.vet["age"], ' years'),
              ),
              _buildDetailRow(
                Icons.attach_money,
                _formatNumber(widget.vet["salary"], ' EGP'),
              ),
              _buildDetailRow(
                Icons.date_range,
                _formatDate(widget.vet["hireDate"]),
              ),
              _buildDetailRow(
                Icons.work_history,
                _formatNumber(widget.vet["experienceYears"], ' years'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

