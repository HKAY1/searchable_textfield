import 'package:flutter/material.dart';
import 'package:searchable_textfeild/dropdown_menu_items.dart';
import 'package:searchable_textfeild/searchable_textfeild.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Searchable Textfeild Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Searchable Textfeild Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<DropdownMenuItems>> getPostsData({
    String? filter,
    int? page,
    int? limit,
  }) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    return [
      DropdownMenuItems(lable: "Post 1", value: "1"),
      DropdownMenuItems(lable: "Post 2", value: "2"),
      DropdownMenuItems(lable: "Post 3", value: "3"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Text("Text Feild"),
          SizedBox(height: 10),
          SearchableTextField(
            controller: TextEditingController(),
            enabled: true,
            isObscured: false,
            isDropdown: false,
          ),
          SizedBox(height: 30),
          Text("Static List Dropdown with Search"),
          SizedBox(height: 10),
          SearchableTextField(
            controller: TextEditingController(),
            enabled: true,
            isObscured: false,
            isDropdown: true,
            items: [
              DropdownMenuItems(lable: "Apple", value: "1"),
              DropdownMenuItems(lable: "Mango", value: "2"),
              DropdownMenuItems(lable: "StrawBerry", value: "3"),
              DropdownMenuItems(lable: "Lichi", value: "4"),
              DropdownMenuItems(lable: "Orange", value: "5"),
              DropdownMenuItems(lable: "Blue Berry", value: "6"),
            ],
            appendableItems: [
              ListTile(
                leading: Icon(Icons.add),
                title: Text("Add New Item"),
                onTap: () {
                  print("Add New Item tapped");
                },
              ),
            ],
          ),
          SizedBox(height: 30),
          Text("Dropdown with Api Search"),
          SizedBox(height: 10),
          SearchableTextField(
            controller: TextEditingController(),
            enabled: true,
            isObscured: false,
            isDropdown: true,
            getItems: getPostsData,
            loadingWidget: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(strokeWidth: 1),
                ),
                SizedBox(width: 10),
                Text('Loading...', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
