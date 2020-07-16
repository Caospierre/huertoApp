import 'package:flutter/material.dart';
//import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/src/bloc/home_bloc.dart';
import 'package:huerto_app/src/module/home_module.dart';
import 'package:huerto_app/utils/colors.dart';
import 'package:huerto_app/src/pages/home/tabs/account.dart';
import 'package:huerto_app/src/pages/home/tabs/search.dart';
import 'package:huerto_app/src/pages/home/tabs/saved.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/src/routes/router.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  signout() async {
    GetIt.I<InitServices>().authService.signout();
  }

  @override
  void initState() {
    super.initState();
    GetIt.I<InitServices>()
        .authService
        .checkAuthenticationHome(context, NavigatorToPath.SignIn);
    GetIt.I<InitServices>().authService.getUser();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text("Foodie 😍",
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 28.0)),
      centerTitle: true,
      bottom: TabBar(
        unselectedLabelColor: unselectedTabLabelColor,
        labelColor: Theme.of(context).primaryColor,
        labelPadding: EdgeInsets.only(left: 0.0, right: 0.0),
        indicatorWeight: 5.0,
        indicator: BoxDecoration(
          gradient: primaryGradient,
        ),
        tabs: <Widget>[
          _buildTab(Icons.search),
          _buildTab(Icons.star),
          _buildTab(Icons.account_circle),
        ],
      ),
    );

    final body = TabBarView(
      children: [
        SearchPage(),
        SavedPage(),
        AccountPage(),
      ],
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: appBar,
        body: body,
      ),
    );
  }

  Widget _buildTab(IconData icon) {
    return Container(
      height: 40.0,
      alignment: Alignment.center,
      color: Colors.white,
      child: Icon(icon, size: 40.0),
    );
  }
}
