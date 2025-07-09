import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:farmxpert/features/authentication/screens/api_maneger/model/GetAllResponse.dart';

class WorkerCard extends StatefulWidget {
  final GetAllResponse worker;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onImagePick;

  const WorkerCard({
    Key? key,
    required this.worker,
    required this.onDelete,
    required this.onEdit,
    required this.onImagePick,
  }) : super(key: key);

  @override
  State<WorkerCard> createState() => _WorkerCardState();
}

class _WorkerCardState extends State<WorkerCard> {
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
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green.shade100,
                    backgroundImage: widget.worker.imageUrl != null &&
                            widget.worker.imageUrl!.isNotEmpty
                        ? NetworkImage(
                            "http://farmxpertapi.runasp.net${widget.worker.imageUrl!}")
                        : null,
                    child: widget.worker.imageUrl == null ||
                            widget.worker.imageUrl!.isEmpty
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
                        widget.worker.name ?? 'Unnamed Worker',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.worker.specialty ?? 'No specialty specified',
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
              _buildDetailRow(Icons.tag, widget.worker.code ?? 'Not assigned'),
              _buildDetailRow(Icons.credit_card,
                  widget.worker.nationalID ?? 'Not provided'),
              _buildDetailRow(
                  Icons.phone, widget.worker.phone ?? 'Not available'),
              _buildDetailRow(
                  Icons.email, widget.worker.email ?? 'Not provided'),

              // Password Row
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
              _buildDetailRow(
                  Icons.cake, _formatNumber(widget.worker.age, ' years')),
              _buildDetailRow(Icons.attach_money,
                  _formatNumber(widget.worker.salary, ' EGP')),
              _buildDetailRow(
                  Icons.date_range, _formatDate(widget.worker.createdAt)),
              _buildDetailRow(Icons.work_history,
                  _formatNumber(widget.worker.experience, ' years')),
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
