import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final GlobalKey<FormState> formKey;
  final Function filterFunction;

  const CustomAppBar({
    super.key,
    required this.searchController,
    required this.formKey,
    required this.filterFunction,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Center(
        child: SvgPicture.asset(
          'assets/x_logo.svg',
          height: 30,
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
                    hintStyle: const TextStyle(color: Colors.white10),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30.0)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 20.0),
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
                child: const Icon(size: 35, color: Colors.black, Icons.search),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(
      kToolbarHeight + 60); // 60 is the height of the bottom widget
}
