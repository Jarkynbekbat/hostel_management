import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hostel_app/data/models/category.dart';
import 'package:hostel_app/data/repositories/repository.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/modal_dialogs/make_sure_dialog.dart';

import 'component/category_add_screen.dart';
import 'component/category_edit_screen.dart';

class CategoriesScreen extends StatefulWidget {
  static final String route = 'categories_screen';
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Repository repository = Repository();
  List<Category> categories = [];

  @override
  void initState() {
    _loadcategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Категории номеров'),
        centerTitle: true,
      ),
      body: categories.length == 0 ? _buildLoading() : _buildLoaded(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CategoryAddScreen(),
            ),
          );
          _loadcategories();
        },
      ),
    );
  }

  Future _loadcategories() async {
    categories = await repository.getAll<Category>();
    print('object');
    setState(() {});
  }

  ListView _buildLoaded() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: 'изменить',
                color: Colors.blue,
                icon: Icons.edit,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryEditScreen(category: categories[index]),
                    ),
                  );
                  _loadcategories();
                },
              ),
              IconSlideAction(
                caption: 'удалить',
                color: Colors.indigo,
                icon: Icons.delete_outline,
                onTap: () async => await _onDelete(categories[index]),
              ),
            ],
            child: ListTile(
              leading: Icon(Icons.account_box),
              title: Text(categories[index].name),
              subtitle: Text(categories[index].description),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: categories.length);
  }

  Future _onDelete(model) async {
    bool res = await showMakeSureDialog(
      context: context,
      title: 'Удаление',
      content: 'Вы уверены что хотите удалить выбранную категорию?',
      ok: 'удалить',
      onOk: () {},
    );
    if (res) {
      categories = await repository.delete<Category>(model);
      setState(() {});
    }
  }

  Center _buildLoading() => Center(child: CircularProgressIndicator());
}
