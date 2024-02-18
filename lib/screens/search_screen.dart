import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../export.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BannerWidget(),
      appBar: AppBar(title: const Text('Search')),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(_result ?? '', style: const TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () async {
                var result = await showSearch<String>(
                  context: context,
                  delegate: CustomDelegate(),
                );
                setState(() => _result = result);
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDelegate extends SearchDelegate<String> {
  AppController controller = Get.find<AppController>();

  // List<String> data = controller.surahNames;

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.chevron_left),
      onPressed: () => close(context, ''));

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  Widget buildSuggestions(BuildContext context) {
    List<SurahModel> listToShow;
    if (query.isNotEmpty) {
      listToShow = controller.surahs.where((SurahModel e) {
        bool search = e.englishName.contains(
                RegExp(query.replaceAll(' ', '-'), caseSensitive: false)) ||
            e.name.contains(
                RegExp(query, caseSensitive: false)) ||
            e.englishNameTranslation.contains(
                RegExp(query, caseSensitive: false));
        return search;
      }).toList();
    } else {
      listToShow = controller.surahs;
    }
    // && e.toLowerCase().startsWith(query)
    return ListView.builder(
      itemCount: listToShow.length,
      itemBuilder: (_, i) {
        SurahModel dataItem = listToShow[i];
        return MyListTile(
          dataItem: dataItem,
        );
        // var noun = listToShow[i];
        // return ListTile(
        //   title: Text(noun),
        //   onTap: () => close(context, noun),
        // );
      },
    );
  }
}

extension StringExtensions on String {
  bool containsIgnoreCase(String secondString) =>
      toLowerCase().contains(secondString.toLowerCase());

//bool isNotBlank() => this != null && this.isNotEmpty;
}
