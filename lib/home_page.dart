import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map> listData = [];
  bool ascending = true;

  create() {
    final controllerTitle = TextEditingController();
    final controllerDescription = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create'),
          titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          contentPadding: const EdgeInsets.all(16),
          children: [
            DInput(
              controller: controllerTitle,
              hint: 'Title',
            ),
            const SizedBox(height: 16),
            DInput(
              controller: controllerDescription,
              hint: 'Description',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Map item = {
                  'id': UniqueKey().toString(),
                  'title': controllerTitle.text,
                  'description': controllerDescription.text,
                };

                // add data
                listData.add(item);

                /** additional for next implemenattion
                 * execute to api */

                // trigger update ui
                setState(() {});

                // logging
                DMethod.printTitle('Create', listData.toString());

                // close dialog
                Navigator.pop(context);

                // show notif to user
                DInfo.snackBarSuccess(context, 'Success Create New Data');
              },
              child: const Text('Create New Data'),
            ),
          ],
        );
      },
    );
  }

  read() {
    // logging
    DMethod.printTitle('read -  before get data', listData.toString());

    // get data from database/api/collection
    List<Map> initialList = [
      {
        'id': '001',
        'title': 'Container',
        'description': 'Wrapper widget that contains size and styling',
      },
      {
        'id': '002',
        'title': 'Neumorphism',
        'description': '3d shape use optic view',
      }
    ];

    // move data
    listData = initialList;
    setState(() {});

    // logging
    DMethod.printTitle('read -  after get data', listData.toString());
  }

  update(Map oldItemData, int index) {
    final controllerTitle = TextEditingController(text: oldItemData['title']);
    final controllerDescription =
        TextEditingController(text: oldItemData['description']);
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Update'),
          titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          contentPadding: const EdgeInsets.all(16),
          children: [
            DInput(
              controller: controllerTitle,
              hint: 'Title',
            ),
            const SizedBox(height: 16),
            DInput(
              controller: controllerDescription,
              hint: 'Description',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Map newItem = {
                  'id': oldItemData['id'],
                  'title': controllerTitle.text,
                  'description': controllerDescription.text,
                };

                // update data
                listData[index] = newItem;

                /** additional for next implemenattion
                 * execute to api */

                // trigger update ui
                setState(() {});

                // logging
                DMethod.printTitle('update', listData.toString());

                // close dialog
                Navigator.pop(context);

                // show notif to user
                DInfo.snackBarSuccess(context, 'Success Update Data');
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  delete(int index) {
    // logging
    DMethod.printTitle('delete - before', listData.toString());

    // delete from list
    listData.removeAt(index);

    // trigger ui
    setState(() {});

    // logging
    DMethod.printTitle('delete - after', listData.toString());

    // notif to user
    DInfo.snackBarError(context, 'Delete From List');
  }

  deleteById(String id) {
    // logging
    DMethod.printTitle('delete by id - before', listData.toString());

    // delete from list
    listData.removeWhere((element) => element['id'] == id);

    // trigger ui
    setState(() {});

    // logging
    DMethod.printTitle('delete by id - after', listData.toString());

    // notif to user
    DInfo.snackBarError(context, 'Delete From List');
  }

  sort() {
    ascending = !ascending;

    if (ascending) {
      listData.sort((a, b) => a['title'].compareTo(b['title']));
    } else {
      listData.sort((a, b) => b['title'].compareTo(a['title']));
    }

    setState(() {});
  }

  @override
  void initState() {
    read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic CRUD with Collection'),
        actions: [
          Column(
            children: [
              IconButton(
                onPressed: () => sort(),
                iconSize: 20,
                icon: const Icon(Icons.sort_by_alpha_outlined),
                tooltip: ascending ? 'Ascending' : 'Descending',
              ),
              Icon(
                ascending ? Icons.arrow_downward : Icons.arrow_upward,
                size: 15,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => create(),
        child: const Icon(Icons.add),
      ),
      body: listData.isEmpty
          ? const Center(child: Text('Empty'))
          : ListView.builder(
              itemCount: listData.length,
              itemBuilder: (context, index) {
                Map item = listData[index];
                return ListTile(
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'update') {
                        update(item, index);
                      }
                      if (value == 'delete') {
                        // delete(index);
                        deleteById(item['id']);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'update',
                        child: Text('Update'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
