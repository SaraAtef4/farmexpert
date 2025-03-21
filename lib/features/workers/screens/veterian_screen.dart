import 'package:flutter/material.dart';

class VeterianScreen extends StatefulWidget {
  const VeterianScreen({super.key});

  @override
  State<VeterianScreen> createState() => _VeterianScreenState();
}

class _VeterianScreenState extends State<VeterianScreen> {
  List<Map<String, String>> veterinarians = [
    {"name": "Dr. Ahmed Alaa", "specialty": "Nutrition"},
    {"name": "Dr. Ahmed Alaa", "specialty": "Animal Surgery"},
    {"name": "Dr. Amany Ahmed", "specialty": "Livestock Health"},
    {"name": "Dr. Ali Hassan", "specialty": "Dairy Cattle"},
    {"name": "Dr. Sarah Kamal", "specialty": "Equine Medicine"},
    {"name": "Dr. Mohamed Salah", "specialty": "Poultry Health"},
    {"name": "Dr. Nour Eldin", "specialty": "Pet Surgery"},
    {"name": "Dr. Karim Ezz", "specialty": "Sheep&Goat Health"},
    {"name": "Dr. Mohsen Sami", "specialty": " Dermatological Diseases"},
  ];

  List<Map<String, String>> filteredVeterinarians = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    filteredVeterinarians = List.from(veterinarians);
  }

  void filterSearch(String query) {
    setState(() {
      filteredVeterinarians = veterinarians
          .where(
              (vet) => vet["name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void deleteVeterinarian(int index) {
    setState(() {
      veterinarians.removeWhere(
          (vet) => vet["name"] == filteredVeterinarians[index]["name"]);
      filteredVeterinarians.removeAt(index);
    });
  }

  void addVeterinarian(String name, String specialty) {
    setState(() {
      veterinarians.add({"name": name, "specialty": specialty});
      filterSearch(searchController.text);
    });
  }

  void showAddVeterinarianDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController specialtyController = TextEditingController();

    FocusNode nameFocus = FocusNode();
    FocusNode specialtyFocus = FocusNode();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add Veterinarian",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: nameController,
                  focusNode: nameFocus,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(
                      color: nameFocus.hasFocus ? Colors.green : Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.person,
                        color: Colors.green ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: specialtyController,
                  focusNode: specialtyFocus,
                  decoration: InputDecoration(
                    labelText: "Specialty",
                    labelStyle: TextStyle(
                      color:
                          specialtyFocus.hasFocus ? Colors.green : Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.medical_services,
                        color: Colors.green ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isNotEmpty &&
                            specialtyController.text.isNotEmpty) {
                          addVeterinarian(
                              nameController.text, specialtyController.text);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Add",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Farm Veterinarians",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              focusNode: searchFocusNode,
              decoration: InputDecoration(
                hintText: "Search Veterinarian...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
              onChanged: filterSearch,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.75,
                ),
                itemCount: filteredVeterinarians.length,
                itemBuilder: (context, index) {
                  final vet = filteredVeterinarians[index];
                  return VeterianCard(
                    name: vet["name"]!,
                    specialty: vet["specialty"]!,
                    onDelete: () => deleteVeterinarian(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddVeterinarianDialog,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(Icons.add, size: 45),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class VeterianCard extends StatelessWidget {
  final String name;
  final String specialty;
  final VoidCallback onDelete;

  const VeterianCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete, color: Colors.red, size: 20),
              ),
            ),
          ),
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.green.shade100,
            child: const Icon(Icons.medical_services,
                color: Colors.green, size: 35),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            specialty,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "More Details",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_sharp,
                  color: Colors.green,
                  size: 20,
                  weight: 900,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
