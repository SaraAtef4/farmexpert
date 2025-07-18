// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:intl/intl.dart';
// import 'dart:io';
//
// import '../../authentication/screens/api_maneger/model/GetAllResponse.dart';
//
// class VeterinarianCard extends StatefulWidget {
//   final GetAllResponse veterinair;
//   final VoidCallback onDelete;
//   final VoidCallback onEdit;
//   final VoidCallback onImagePick;
//
//   const VeterinarianCard({
//     Key? key,
//     required this.veterinair,
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
//   bool _showPassword = false;
//   double rating = 0.0;
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
//             // Header Section
//             Row(
//               children: [
//                 // Profile Image
//                 GestureDetector(
//                   onTap: widget.onImagePick,
//                   child: CircleAvatar(
//                     radius: 30,
//                     backgroundColor: Colors.green.shade100,
//                     backgroundImage: widget.veterinair.imageUrl != null &&
//                             widget.veterinair.imageUrl!.isNotEmpty
//                         ? NetworkImage(
//                             "http://farmxpertapi.runasp.net${widget.veterinair.imageUrl!}")
//                         : null,
//                     child: widget.veterinair["image"] == null
//                         ? const Icon(
//                             Icons.person,
//                             size: 30,
//                             color: Colors.green,
//                           )
//                         : null,
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//
//                 // Name and Specialty
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.veterinair["name"]?.toString() ??
//                             'Unnamed Veterinarian',
//                         style: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       Text(
//                         widget.veterinair["specialty"]?.toString() ??
//                             'No specialty',
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
//                             (widget.veterinair["rating"] as num?)?.toDouble() ??
//                                 0.0,
//                         minRating: 1,
//                         direction: Axis.horizontal,
//                         allowHalfRating: true,
//                         itemCount: 5,
//                         itemSize: 20,
//                         itemBuilder: (context, _) =>
//                             const Icon(Icons.star, color: Colors.amber),
//                         onRatingUpdate: (rating) {
//                           setState(() {
//                             widget.veterinair["rating"] = rating;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Action Buttons
//                 IconButton(
//                   icon: const Icon(Icons.edit),
//                   color: Colors.green,
//                   // onPressed: widget.onEdit,
//                   onPressed: () {},
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   color: Colors.red,
//                   // onPressed: widget.onDelete,
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//
//             // Expand/Collapse Button
//             const SizedBox(height: 10),
//             InkWell(
//               onTap: () => setState(() => _isExpanded = !_isExpanded),
//               child: Center(
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       _isExpanded ? "Hide Details" : "Show Details",
//                       style: const TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Icon(
//                       _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
//                       color: Colors.green,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Expanded Details
//             if (_isExpanded) ...[
//               const SizedBox(height: 16),
//               _buildDetailRow(Icons.tag,
//                   widget.veterinair["code"]?.toString() ?? 'Not assigned'),
//               _buildDetailRow(
//                 Icons.credit_card,
//                 widget.veterinair["nationalId"]?.toString() ?? 'Not provided',
//               ),
//               _buildDetailRow(
//                 Icons.phone,
//                 widget.veterinair["phone"]?.toString() ?? 'Not available',
//               ),
//               _buildDetailRow(
//                 Icons.email,
//                 widget.veterinair["email"]?.toString() ?? 'Not provided',
//               ),
//
//               // Password Row with Toggle Visibility
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   children: [
//                     Icon(Icons.lock, color: Colors.green, size: 24),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         _showPassword
//                             ? widget.veterinair["password"] ?? 'Not set'
//                             : '*******',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(
//                         _showPassword ? Icons.visibility_off : Icons.visibility,
//                         size: 20,
//                         color: Colors.green,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _showPassword = !_showPassword;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//
//               _buildDetailRow(
//                 Icons.cake,
//                 _formatNumber(widget.veterinair["age"], ' years'),
//               ),
//               _buildDetailRow(
//                 Icons.attach_money,
//                 _formatNumber(widget.veterinair["salary"], ' EGP'),
//               ),
//               _buildDetailRow(
//                 Icons.date_range,
//                 _formatDate(widget.veterinair["hireDate"]),
//               ),
//               _buildDetailRow(
//                 Icons.work_history,
//                 _formatNumber(widget.veterinair["experienceYears"], ' years'),
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
import '../../authentication/screens/api_maneger/model/GetAllResponse.dart';

class VeterinarianCard extends StatefulWidget {
  final GetAllResponse veterinair;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onImagePick;

  const VeterinarianCard({
    Key? key,
    required this.veterinair,
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
  double rating = 0.0;

  String _formatDate(String? date) {
    try {
      if (date == null || date.isEmpty) return 'Not set';
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    } catch (e) {
      return 'Invalid date format';
    }
  }

  String _formatNumber(dynamic value, [String suffix = '']) {
    if (value == null) return '0$suffix';
    return '$value$suffix';
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
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onImagePick,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green.shade100,
                    backgroundImage: widget.veterinair.imageUrl != null &&
                        widget.veterinair.imageUrl!.isNotEmpty
                        ? NetworkImage(
                        "http://farmxpertapi.runasp.net${widget.veterinair.imageUrl!}")
                        : null,
                    child: widget.veterinair.imageUrl == null ||
                        widget.veterinair.imageUrl!.isEmpty
                        ? const Icon(Icons.person,
                        color: Colors.green, size: 30)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.veterinair.name ?? 'Unnamed Veterinarian',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.veterinair.specialty ?? 'No specialty specified',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (newRating) {
                          setState(() {
                            rating = newRating;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.onEdit,
                  icon: const Icon(Icons.edit, color: Colors.green),
                ),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              _buildDetailRow(Icons.tag, widget.veterinair.code ?? 'Not assigned'),
              _buildDetailRow(Icons.credit_card, widget.veterinair.nationalID ?? 'Not provided'),
              _buildDetailRow(Icons.phone, widget.veterinair.phone ?? 'Not available'),
              _buildDetailRow(Icons.email, widget.veterinair.email ?? 'Not provided'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.lock, color: Colors.green, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _showPassword ? "********" : "*******",
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
              _buildDetailRow(Icons.cake, _formatNumber(widget.veterinair.age, ' years')),
              _buildDetailRow(Icons.attach_money, _formatNumber(widget.veterinair.salary, ' EGP')),
              _buildDetailRow(Icons.date_range, _formatDate(widget.veterinair.createdAt)),
              _buildDetailRow(Icons.work_history, _formatNumber(widget.veterinair.experience, ' years')),
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
