import 'package:db_sqlite/add_not_page.dart';
import 'package:db_sqlite/data/local/db_helper.dart';
import 'package:db_sqlite/db_provider.dart';
import 'package:db_sqlite/settings_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<DBProvider>().getInitialNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          PopupMenuButton(itemBuilder: (_) {
            return [
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(
                      width: 15,
                    ),
                    Text("Settings")
                  ],
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              )
            ];
          })
        ],
      ),

      /// all notes viewed here
      body: Consumer<DBProvider>(builder: (cts, provider, __) {
        List<Map<String, dynamic>> allNotes = provider.getNotes();

        return allNotes.isNotEmpty
            ? ListView.builder(
                itemCount: allNotes.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    // leading: Text('${allNotes[index][DBHelper.columnNoteSno]}'),
                    leading: Text('${index + 1}'),
                    title: Text(allNotes[index][DBHelper.columnNoteTitle]),
                    subtitle: Text(allNotes[index][DBHelper.columnNoteDesc]),
                    trailing: SizedBox(
                      width: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddNotPage(
                                              isUpdate: true,
                                              title: allNotes[index]
                                                  [DBHelper.columnNoteTitle],
                                              desc: allNotes[index]
                                                  [DBHelper.columnNoteDesc],
                                              sno: allNotes[index]
                                                  [DBHelper.columnNoteSno],
                                            )));
                              },
                              child: const Icon(Icons.edit)),
                          InkWell(
                            onTap: () {
                              int sno = allNotes[index][DBHelper.columnNoteSno];
                              context.read<DBProvider>().deleteNote(sno);
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
            : const Center(
                child: Text("No Notes Yet!!.."),
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          /// note to be added from here
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNotPage(),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
