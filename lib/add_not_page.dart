import 'package:db_sqlite/db_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNotPage extends StatelessWidget {
  bool isUpdate;
  String title;
  String desc;
  int sno;

  ///controllers
  ///
  TextEditingController titleContrtoller = TextEditingController();
  TextEditingController descContrtoller = TextEditingController();

  // DBHelper? dbRef = DBHelper.getInstance;

  AddNotPage(
      {this.isUpdate = false, this.sno = 0, this.title = "", this.desc = ""});

  @override
  Widget build(BuildContext context) {
    if (isUpdate) {
      titleContrtoller.text = title;
      descContrtoller.text = desc;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isUpdate ? "Update Note" : "Add Note",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(11),
        width: double.infinity,
        child: Column(
          children: [
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
              onChanged: (value) {},
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
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11))),
              onChanged: (value) {},
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
                            if (isUpdate) {
                              context
                                  .read<DBProvider>()
                                  .updateNote(title, desc, sno);
                            } else {
                              context.read<DBProvider>().addNote(title, desc);
                            }

                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Please Fill All Required Fields..!")));
                          }

                          titleContrtoller.clear();
                          descContrtoller.clear();
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
      ),
    );
  }
}
