import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';
import 'package:hostel_app/data/models/category.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/make_sure_dialog.dart';
import 'component/category_add_screen.dart';
import 'component/category_edit_screen.dart';

class CategoriesScreen extends StatefulWidget {
  static final String route = 'categories_screen';
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Category> categories = [];
  @override
  void initState() {
    _loadcategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
    categories = BlocProvider.of<NumbersBloc>(context).repository.categories;
    if (categories[0].name == 'все') categories.removeAt(0);
    setState(() {});
  }

  ListView _buildLoaded() {
    return ListView.builder(
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
            leading: Icon(Icons.category),
            title: Text(categories[index].name),
            subtitle: Text(categories[index].description),
          ),
        );
      },
      itemCount: categories.length,
    );
  }

  Future _onDelete(Category model) async {
    bool res = await showMakeSureDialog(
      context: context,
      title: 'Удаление',
      content: 'Вы уверены что хотите удалить выбранную категорию?',
      ok: 'удалить',
      onOk: () {},
    );
    if (res) {
      bool hasNumbers = BlocProvider.of<NumbersBloc>(context)
          .repository
          .numbers
          .map((n) => n.category)
          .contains(model.id);
      if (hasNumbers) {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content:
                Text('К этой категории привязаны номера , сначала удалите их'),
          ),
        );
      } else {
        bool isDeleted = await BlocProvider.of<NumbersBloc>(context)
            .repository
            .delete<Category>(model);
        if (isDeleted) {
          BlocProvider.of<NumbersBloc>(context)
              .repository
              .categories
              .removeWhere((c) => c.id == model.id);
          _loadcategories();
        } else {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content:
                  Text('Не удалось удалить,проверьте интернет соединение!'),
            ),
          );
        }
      }
    }
  }

  Center _buildLoading() => Center(child: CircularProgressIndicator());
}
