import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/home_bloc.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/utils/utils.dart';
//import 'package:hasura_connect/hasura_connect.dart';
import 'package:huerto_app/utils/colors.dart';
import 'package:huerto_app/src/pages/home/tabs/account.dart';
import 'package:huerto_app/src/pages/home/tabs/search.dart';
import 'package:huerto_app/src/pages/home/tabs/saved.dart';

import 'package:huerto_app/src/routes/router.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bloc = HomeBloc(GetIt.I<InitServices>().hasuraService.appRepository);
  Stream<List<PublicationModel>> slistp;

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
      title: Text("Mi cosecho",
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
    this.slistp = bloc.publicationsController;
    final body = TabBarView(
      children: [
        SearchPage(this.slistp),
        SavedPage(this.slistp),
        //AccountPage(),
        AccountPage(this.slistp),
      ],
    );

    return DefaultTabController(
      length: 3,
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Started.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            appBar: appBar,
            body: body,
          )),
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
