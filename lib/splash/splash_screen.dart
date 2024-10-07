import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:learn_sqllite/splash/sql/sql_helper.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void _refreshJournals() async {
    final data=await SQLHelper.getItems();
    setState(() {
      _journals=data;
      _isLoading=false;
    });
  }

  @override
  void initState() {
  super.initState();
  _refreshJournals();
  print("...number of items ${_journals.length}");
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(_titleController.text, _descriptionController.text);
    _refreshJournals();
    print("...number of items ${_journals.length}");
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(id, _titleController.text, _descriptionController.text);
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully deleted a journals")));
    _refreshJournals();
  }

  void _showForm(int? id) async {
    if(id != null) {
      final existingJournal = _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 50
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  )
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    hintText: 'descriptions',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: () async {
                    if(id==null) {
                      await _addItem();
                    }
                    if(id != null) {
                      await _updateItem(id);
                    }
                    _titleController.text = '';
                    _descriptionController.text = '';
                    Navigator.of(context).pop();

                  },
                  child: Text(id==null ? 'Create New' : 'Update')
              )
            ],
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    List<Color> color=[
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.deepOrange
    ];
    return Container(
      color: Colors.white,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: color,
              begin: Alignment.centerLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child:  ListView.builder(
              itemCount: _journals.length,
              itemBuilder: (context, index) => Card(
                color: Colors.orange[200],
                margin: EdgeInsets.all(15),
                child: ListTile(
                  title: Text(_journals[index]['title'], style: TextStyle( fontWeight: FontWeight.bold),),
                  subtitle: Text(_journals[index]['description'],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(onPressed: () {
                          _showForm(_journals[index]['id']);
                        }, icon: const Icon(Icons.edit)),
                        IconButton(onPressed: () => _deleteItem(_journals[index]['id']), icon: const Icon(Icons.delete))
                      ],
                    ),
                  ),
                ),
              )
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: ()=> _showForm(null),
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, color: Colors.white,),
        ),
      ),
    );
  }
}
