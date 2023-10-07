import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '/src/provider/search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> filterFunction() async {
    bool isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    await Provider.of<SearchProvider>(context, listen: false)
        .searchResponse(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: SvgPicture.asset(
            'assets/x_logo.svg', // Replace with your SVG icon path
            height: 30, // Adjust the height as needed
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Form(
            key: formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a name first";
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'elonmusk',
                      hoverColor: Colors.white,
                      labelStyle:
                          const TextStyle(fontSize: 20, color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30.0)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30.0),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal:
                              20.0), // Adjust the values for vertical and horizontal padding
                    ),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    onFieldSubmitted: (text) {
                      filterFunction();
                    },
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 10.0),
                  ),
                  onPressed: () {
                    filterFunction();
                  },
                  child:
                      const Icon(size: 35, color: Colors.black, Icons.search),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, child) {
          return provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : ListView.builder(
                  itemCount: provider.response?.length ?? 0,
                  itemBuilder: (context, index) {
                    final name = provider.response![index].name;
                    final link = provider.response![index].link;

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 1),
                      child: GestureDetector(
                        onTap: () async {
                          final url = link!; // You can safely use link here
                          await launch(url);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white24,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              '$name',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              '$link',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            tileColor: Colors.white10,
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
