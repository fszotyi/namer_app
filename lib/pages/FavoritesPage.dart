import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/main.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${appState.favorites.length} favorites:'),
        ),
        for (var entry in appState.favorites.entries)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(entry.value),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () =>
                      _showRenameDialog(context, entry.key, appState),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _showDeleteConfirmationDialog(
                      context, entry.key, appState),
                ),
              ],
            ),
            onTap: () =>
                _showDeleteConfirmationDialog(context, entry.key, appState),
          ),
      ],
    );
  }
}

void _showDeleteConfirmationDialog(
    BuildContext context, WordPair pair, MyAppState appState) {
  String favoriteName = appState.favorites[pair] ?? pair.asLowerCase;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Remove Favorite'),
      content: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(text: 'Are you sure you want to remove "'),
            TextSpan(
              text: '$favoriteName',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '" from your favorites?'),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('No'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            appState.removeFavorite(pair);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

void _showRenameDialog(
    BuildContext context, WordPair pair, MyAppState appState) {
  String currentName = appState.favorites[pair] ?? pair.asLowerCase;
  TextEditingController _textFieldController =
      TextEditingController(text: currentName);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Rename Favorite'),
        content: TextField(
          controller: _textFieldController,
          decoration: InputDecoration(hintText: "Write a new name"),
          autofocus: true,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              if (_textFieldController.text.isNotEmpty &&
                  _textFieldController.text != currentName) {
                appState.renameFavorite(pair, _textFieldController.text);
              }
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
