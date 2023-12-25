import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/src/components/account_handles_list.dart';
import 'package:sherlock/src/components/search_app_bar.dart';

import '/src/provider/search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
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
        appBar: CustomAppBar(
            searchController: searchController,
            formKey: formKey,
            filterFunction: filterFunction),
        body: Consumer<SearchProvider>(
          builder: (context, provider, child) {
            return AccountHandlesListBody(provider: provider);
          },
        ));
  }
}
