import 'package:huerto_app/src/home/home_bloc.dart';
import 'package:huerto_app/src/home/home_module.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bloc = HomeModule.to.bloc<HomeBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body:Container(
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Started.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<List<publicationModel>>(
            stream: bloc.publicationsController,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data[index].user.name),
                          subtitle: Text(snapshot.data[index].content),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5,0,5,5),
                    child: TextField(
                      controller: bloc.controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: bloc.sendPublication,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
      ) 
          );
  }
}
