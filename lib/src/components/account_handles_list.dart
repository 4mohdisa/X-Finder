import 'package:flutter/material.dart';
import 'package:sherlock/src/provider/search_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountHandlesListBody extends StatelessWidget {
  final SearchProvider provider;

  const AccountHandlesListBody({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return ListView.builder(
      itemCount: provider.response?.length ?? 0,
      itemBuilder: (context, index) {
        final name = provider.response![index].name;
        final link = provider.response![index].link;

        return Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 1),
          child: GestureDetector(
            onTap: () async {
              final url = link!;
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
  }
}
