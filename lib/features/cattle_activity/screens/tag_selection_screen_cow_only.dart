
import 'package:flutter/material.dart';
import 'package:farmxpert/core/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/screens/api_maneger/APIManeger.dart';
import '../../authentication/screens/api_maneger/model/get_cattle_model_response.dart';


class TagSelectionScreenCowOnly extends StatefulWidget {
  final bool femalesOnly;

  const TagSelectionScreenCowOnly({Key? key, this.femalesOnly = false}) : super(key: key);

  @override
  _TagSelectionScreenCowOnlyState createState() => _TagSelectionScreenCowOnlyState();
}

class _TagSelectionScreenCowOnlyState extends State<TagSelectionScreenCowOnly> {
  TextEditingController searchController = TextEditingController();
  List<String> allTags = [];
  List<String> filteredTags = [];
  bool isSearchFocused = false;
  bool isLoading = false;
  List<CattleModel> cowsList = [];


  @override
  void initState() {
    super.initState();
    loadCowTagsFromApi();
  }

  void loadDummyTags() {
    allTags = ["001", "002", "003"];
    filteredTags = List.from(allTags);
  }

  Future<void> loadCowTagsFromApi() async {
    setState(() => isLoading = true);

    final cows = await ApiManager.getCowsOnly();

    if (cows.isNotEmpty) {
      setState(() {
        cowsList = cows;
        allTags = cows.map((e) => e.cattleID.toString()).toList();
        filteredTags = List.from(allTags);
        isLoading = false;
      });
    } else {
      setState(() {
        allTags = [];
        filteredTags = [];
        isLoading = false;
      });
    }
  }

  void filterTags(String query) {
    setState(() {
      filteredTags = allTags
          .where((tag) => tag.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void selectTag(String tag) {
    Navigator.pop(context, tag);
  }

  Widget _buildTagCard(String tag) {
    final cow = cowsList.firstWhere((e) => e.cattleID.toString() == tag);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => selectTag(tag),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tag Number: $tag",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 4),
                      Text("Type: Cow",
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 14)),
                      Text("Gender: ${cow.gender}",
                          style: TextStyle(
                            color: cow.gender == "Female"
                                ? Colors.pink.shade700
                                : Colors.blue.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: Colors.grey[400], size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.femalesOnly ? "Select Female Tag" : "Select Tag"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Search bar
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(16, 16, 16, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Focus(
              onFocusChange: (hasFocus) =>
                  setState(() => isSearchFocused = hasFocus),
              child: TextField(
                controller: searchController,
                cursorColor: AppColors.secondaryColor,
                style:
                TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                decoration: InputDecoration(
                  hintText: "Search for tag number",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w300),
                  prefixIcon: Icon(Icons.search,
                      color: isSearchFocused
                          ? Theme.of(context).primaryColor
                          : Colors.grey[400]),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear,
                        color: Colors.grey[500]),
                    onPressed: () {
                      searchController.clear();
                      filterTags("");
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: filterTags,
              ),
            ),
          ),
          // Tag list or no result
          if (filteredTags.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  "No tags found",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: filteredTags.length,
                itemBuilder: (context, index) =>
                    _buildTagCard(filteredTags[index]),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
