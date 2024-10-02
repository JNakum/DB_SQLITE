import 'package:db_sqlite/data/local/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ///controllers
  ///
  TextEditingController titleContrtoller = TextEditingController();
  TextEditingController descContrtoller = TextEditingController();

  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    allNotes = await dbRef!.getAllNotes();
    setState(() {
      print("Notes updated: $allNotes");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),

      /// all notes viewed here
      body: allNotes.isNotEmpty
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
                              // Setting the existing title and description into controllers
                              titleContrtoller.text =
                                  allNotes[index][DBHelper.columnNoteTitle];
                              descContrtoller.text =
                                  allNotes[index][DBHelper.columnNoteDesc];

                              // Opening BottomSheet for Update
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return getBottomSheetWidget(
                                        isUpdate: true,
                                        sno: allNotes[index]
                                            [DBHelper.columnNoteSno]);
                                  });
                            },
                            child: const Icon(Icons.edit)),
                        InkWell(
                          onTap: () async {
                            bool check = await dbRef!.deleteNote(
                                sno: allNotes[index][DBHelper.columnNoteSno]);
                            if (check) {
                              getNotes();
                            }
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          /// note to be added from here
          // Clearing the controllers when adding new note
          titleContrtoller.clear();
          descContrtoller.clear();

          showModalBottomSheet(
              context: context,
              builder: (context) {
                return getBottomSheetWidget();
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getBottomSheetWidget({bool isUpdate = false, int sno = 0}) {
    return Container(
      padding: const EdgeInsets.all(11),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            isUpdate ? "Update Note" : "Add Note",
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 21,
          ),
          TextField(
            controller: titleContrtoller,
            decoration: InputDecoration(
                hintText: "Enter Title Here..!",
                label: const Text("Title *"),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11))),
            onChanged: (value) {
              // Update the titleContrtoller when user types
              setState(() {
                titleContrtoller.text = value;
                titleContrtoller.selection = TextSelection.fromPosition(
                    TextPosition(offset: titleContrtoller.text.length));
              });
            },
          ),
          const SizedBox(
            height: 11,
          ),
          TextField(
            controller: descContrtoller,
            maxLines: 4,
            decoration: InputDecoration(
                hintText: "Enter Desc Here...!",
                label: const Text("Desc *"),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11))),
            onChanged: (value) {
              // Update the descContrtoller when user types
              setState(() {
                descContrtoller.text = value;
                descContrtoller.selection = TextSelection.fromPosition(
                    TextPosition(offset: descContrtoller.text.length));
              });
            },
          ),
          const SizedBox(
            height: 11,
          ),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                              side: const BorderSide(
                                  width: 4, color: Colors.black))),
                      onPressed: () async {
                        var title = titleContrtoller.text;
                        var desc = descContrtoller.text;

                        if (title.isNotEmpty && desc.isNotEmpty) {
                          bool check = isUpdate
                              ? await dbRef!.updateNote(
                                  title: title, desc: desc, sno: sno)
                              : await dbRef!
                                  .addNote(mTitle: title, mDesc: desc);
                          if (check) {
                            getNotes();
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please Fill All Required Fields..!")));
                        }

                        titleContrtoller.clear();
                        descContrtoller.clear();

                        Navigator.pop(context);
                      },
                      child: Text(isUpdate ? "Update Note" : "Add Note"))),
              const SizedBox(
                width: 11,
              ),
              Expanded(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                              side: const BorderSide(
                                  width: 4, color: Colors.black))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"))),
            ],
          )
        ],
      ),
    );
  }
}
