import 'package:flutter/material.dart';
import '../../../test/widgets/milk_text_field.dart';

class CattleAddScreen extends StatefulWidget {
  const CattleAddScreen({super.key});

  @override
  _CattleAddScreenState createState() => _CattleAddScreenState();
}

class _CattleAddScreenState extends State<CattleAddScreen> {
  // Controllers
  final TextEditingController _tagNumberController = TextEditingController();
  final TextEditingController _sourceDetailsController =
      TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _farmEntryDateController =
      TextEditingController();
  final TextEditingController _motherTagController = TextEditingController();
  final TextEditingController _fatherTagController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Gender selection
  String? _selectedGender;

  // Source selection
  String? _selectedSource;
  bool _isOtherSource = false;

  // Breed selection
  String? _selectedBreed;

  // Male specific stage
  String? _maleCattleStage;

  // Female specific fields
  String? _femaleCattleStage;
  String? _femaleReproductiveStatus;
  String? _femaleGeneralStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Cattle'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gender Selection (Required)
            const Text('Select Gender',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Radio<String>(
                  value: 'Male',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                      _femaleCattleStage = null;
                      _femaleReproductiveStatus = null;
                      _femaleGeneralStatus = null;
                    });
                  },
                ),
                const Text('Male'),
                Radio<String>(
                  value: 'Female',
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                      _maleCattleStage = null;
                    });
                  },
                ),
                const Text('Female'),
              ],
            ),
            const SizedBox(height: 16),

            // Tag Number (Required)
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: _tagNumberController,
              label: 'Tag Number',
              hintText: 'Enter Tag Number',
              isRequired: true,
            ),
            const SizedBox(height: 16),

            // Source Selection (Required)
            const Text('Source', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: _selectedSource,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              hint: const Text('Select Source'),
              items: ['Born on Farm', 'Purchase', 'Other']
                  .map((source) => DropdownMenuItem(
                        value: source,
                        child: Text(source),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSource = value;
                  _isOtherSource = value == 'Other';
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a source' : null,
            ),

            // Conditional Other Source Details
            if (_isOtherSource) ...[
              const SizedBox(height: 16),
              MilkTextField(
                width: double.infinity,
                height: 60,
                controller: _sourceDetailsController,
                label: 'Source Details',
                hintText: 'Specify Source',
                isRequired: true,
              ),
            ],
            const SizedBox(height: 16),

            // Breed Selection (Optional)
            const Text('Breed (Optional)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to Breed Selection Screen
              },
              child: const Text('Select Breed'),
            ),
            const SizedBox(height: 16),

            // Stage Selection based on Gender
            if (_selectedGender == 'Male') ...[
              const Text('Male Cattle Stage',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _maleCattleStage,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                hint: const Text('Select Stage'),
                items: ['Calf', 'Weaner', 'Steer', 'Bull']
                    .map((stage) => DropdownMenuItem(
                          value: stage,
                          child: Text(stage),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _maleCattleStage = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a stage' : null,
              ),
            ],

            if (_selectedGender == 'Female') ...[
              const Text('Female Cattle Stage',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _femaleCattleStage,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                hint: const Text('Select Stage'),
                items: ['Calf', 'Weaner', 'Heifer', 'Cow']
                    .map((stage) => DropdownMenuItem(
                          value: stage,
                          child: Text(stage),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _femaleCattleStage = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a stage' : null,
              ),
              const SizedBox(height: 16),

              // Reproductive Status for Females
              const Text('Reproductive Status',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _femaleReproductiveStatus,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                hint: const Text('Select Status'),
                items: [
                  'Pregnant',
                  'Lactating',
                  'Non-Lactating',
                  'Lactating & Pregnant'
                ]
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _femaleReproductiveStatus = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a status' : null,
              ),
              const SizedBox(height: 16),

              // General Status for Females
              const Text('General Status',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                value: _femaleGeneralStatus,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                hint: const Text('Select Status'),
                items: ['Milking Cow', 'Dry', 'Barren', 'Anoestrus']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _femaleGeneralStatus = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a status' : null,
              ),
            ],

            // Optional Fields
            const SizedBox(height: 16),
            const Text('Optional Information',
                style: TextStyle(fontWeight: FontWeight.bold)),

            // Weight
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: _weightController,
              label: 'Weight (kg)',
              hintText: 'Enter Weight',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Date of Birth
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: _dobController,
              label: 'Date of Birth',
              hintText: 'Select Date',
              readOnly: true,
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  _dobController.text = pickedDate.toString().split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 16),

            // Farm Entry Date
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: _farmEntryDateController,
              label: 'Farm Entry Date',
              hintText: 'Select Date',
              readOnly: true,
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  _farmEntryDateController.text =
                      pickedDate.toString().split(' ')[0];
                }
              },
            ),
            const SizedBox(height: 16),

            // Mother Tag
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: _motherTagController,
              label: 'Mother Tag',
              hintText: 'Enter Mother\'s Tag Number',
            ),
            const SizedBox(height: 16),

            // Father Tag
            MilkTextField(
              width: double.infinity,
              height: 60,
              controller: _fatherTagController,
              label: 'Father Tag',
              hintText: 'Enter Father\'s Tag Number',
            ),
            const SizedBox(height: 16),

            // Group (Navigate to Group Selection)
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to Group Selection Screen
              },
              child: const Text('Select Group'),
            ),
            const SizedBox(height: 16),

            // Notes
            MilkTextField(
              width: double.infinity,
              height: 100,
              controller: _notesController,
              label: 'Notes',
              hintText: 'Additional Notes',
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: _saveNewCattle,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Save Cattle',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNewCattle() {
    // Validation logic
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select gender')),
      );
      return;
    }

    if (_tagNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tag Number is required')),
      );
      return;
    }

    if (_selectedSource == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select source')),
      );
      return;
    }

    if (_isOtherSource && _sourceDetailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide source details')),
      );
      return;
    }

    if (_selectedGender == 'Male' && _maleCattleStage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select male cattle stage')),
      );
      return;
    }

    if (_selectedGender == 'Female') {
      if (_femaleCattleStage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select female cattle stage')),
        );
        return;
      }
      if (_femaleReproductiveStatus == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select reproductive status')),
        );
        return;
      }
      if (_femaleGeneralStatus == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select general status')),
        );
        return;
      }
    }

    // Prepare data for saving
    final cattleData = {
      'gender': _selectedGender,
      'tagNumber': _tagNumberController.text,
      'source': _selectedSource,
      'sourceDetails': _isOtherSource ? _sourceDetailsController.text : null,
      'breed': _selectedBreed,
      'stage':
          _selectedGender == 'Male' ? _maleCattleStage : _femaleCattleStage,
      'reproductiveStatus': _femaleReproductiveStatus,
      'generalStatus': _femaleGeneralStatus,
      'weight': _weightController.text,
      'dateOfBirth': _dobController.text,
      'farmEntryDate': _farmEntryDateController.text,
      'motherTag': _motherTagController.text,
      'fatherTag': _fatherTagController.text,
      'notes': _notesController.text,
    };

    // TODO: Call method to save cattle data
    // Provider.of<CattleProvider>(context, listen: false).addCattle(cattleData);

    // Navigate back or show success message
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cattle Added Successfully')),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    _tagNumberController.dispose();
    _sourceDetailsController.dispose();
    _weightController.dispose();
    _dobController.dispose();
    _farmEntryDateController.dispose();
    _motherTagController.dispose();
    _fatherTagController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
