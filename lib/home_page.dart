import 'package:flutter/material.dart';
import 'package:localdatabase_using_sqf/crud_functions.dart';
import 'package:localdatabase_using_sqf/mytextfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _journals = [];

  int? id;

  void _refreshJournals() async {
    final data = await CrudFunctions.getItems();
    setState(() {
      _journals = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals();
    print("Number of items ${_journals.length}");
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desceiptionController = TextEditingController();

  Future<void> _addItems() async {
    await CrudFunctions.createItems(
        _titleController.text, _desceiptionController.text);
    _refreshJournals();
  }

  Future<void> _updateItems(int id) async {
    await CrudFunctions.updateItem(
        id, _titleController.text, _desceiptionController.text);
    _refreshJournals();
  }

  Future<void> _deletItems(int id) async {
    await CrudFunctions.deletItems(id);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Successfully Deleted")));
    _refreshJournals();
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _desceiptionController.text = existingJournal['description'];
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        elevation: 4,
        builder: (_) => Container(
              height: 500,
              padding: EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                children: [
                  MyTextField(controller: _titleController, labelText: 'Title'),
                  const SizedBox(height: 10),
                  MyTextField(
                      controller: _desceiptionController,
                      labelText: 'Description'),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addItems();
                      }
                      if (id != null) {
                        await _updateItems(id);
                      }
                      _titleController.text = '';
                      _desceiptionController.text = '';
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? "Create New" : "Update"),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQFLite'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(null);
        },
        child: Icon(Icons.add_task_outlined),
      ),
      body: ListView.builder(
          itemCount: _journals.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(_journals[index]['title']),
                subtitle: Text(_journals[index]['description']),
                trailing: Container(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            _showForm(_journals[index]['id']);
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            _deletItems(_journals[index]['id']);
                          },
                          icon: Icon(Icons.delete)),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
