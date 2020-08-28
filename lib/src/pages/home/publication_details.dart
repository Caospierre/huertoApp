import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/cultivation_phase_bloc.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/models/user_cultivation_phase_model.dart';
import 'package:huerto_app/src/routes/router.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:huerto_app/src/widgets/home/price_rating_bar.dart';
import 'package:huerto_app/src/widgets/home/rating_bar.dart';

class PublicationDetailsPage extends StatefulWidget {
  final PublicationModel publication;

  PublicationDetailsPage({@required this.publication});

  @override
  _PublicationDetailsPageState createState() => _PublicationDetailsPageState();
}

class _PublicationDetailsPageState extends State<PublicationDetailsPage> {
  List<UserCultivationPhaseModel> listPhase;
  Stream<List<UserCultivationPhaseModel>> strphase;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    CultivationPhaseBloc phasebloc;

    setState(() {
      phasebloc = null;
      strphase = null;
      phasebloc = CultivationPhaseBloc(this.widget.publication.id);
      strphase = phasebloc.cultivationPhaseController;
    });

    final cancelBtn = Positioned(
      top: 50.0,
      left: 20.0,
      child: Container(
        height: 35.0,
        width: 35.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.5),
        ),
        child: IconButton(
          icon: Icon(LineIcons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          iconSize: 20.0,
        ),
      ),
    );

    final imageBg = Hero(
      tag: widget.publication.id,
      child: Container(
        height: screenHeight * 0.7,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.publication.cultivation.product.photo),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    final _filledCircle = Container(
      height: 4.0,
      width: 4.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white60,
      ),
    );

    final _name = Text(
      widget.publication.cultivation.product.name,
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );

    final _location = Row(
      children: <Widget>[
        Text(
          widget.publication.cultivation.name != null
              ? widget.publication.cultivation.name
              : "Indefinido",
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white60,
          ),
        ),
        SizedBox(width: 5.0),
        _filledCircle,
        SizedBox(width: 5.0),
        Text(
          widget.publication.users.name,
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white60,
          ),
        ),
      ],
    );
    final _rating = Row(
      children: <Widget>[
        RatingBar(
          rating: widget.publication.rating + .0,
          color: Colors.white,
          size: 20.0,
        ),
        SizedBox(width: 5.0),
        _filledCircle,
        SizedBox(width: 5.0),
        PriceRatingBar(rating: widget.publication.priceScale, size: 20.0),
      ],
    );

    final _details = Positioned(
      top: screenHeight * 0.50,
      left: 10.0,
      right: 10.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
            height: screenHeight * .15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[_name, _location, _rating],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
        body: StreamBuilder<List<UserCultivationPhaseModel>>(
      stream: strphase,
      builder: (context, snapshot) {
        print("fases " + snapshot.data.toString());

        if (!snapshot.hasData) {
          print("SIN DATA");
          return Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(height: screenHeight - 20),
                  imageBg,
                  cancelBtn,
                  _details,
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  Center(
                    child: Text("Tenemos Inconvi"),
                  )
                ],
              ),
            ],
          );
        } else {
          this.listPhase = snapshot.data;
        }
        return Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(height: screenHeight - 20),
                imageBg,
                cancelBtn,
                _details,
                getSecondSection(context, screenHeight),
              ],
            ),
          ],
        );
      },
    ));
  }

  Positioned getSecondSection(
    BuildContext context,
    double screenHeight,
  ) {
    final _distance = Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Text(
        widget.publication.cultivation.description,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
          color: Colors.blueGrey,
        ),
      ),
    );

    final _description = Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Text(
        widget.publication.cultivation.product.description,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15.0,
          color: Colors.blueGrey,
        ),
      ),
    );

    final _openingHours = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Disponible!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Row(
            children: <Widget>[
              Text(
                "View hours",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.grey.withOpacity(0.4),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.withOpacity(0.4))
            ],
          )
        ],
      ),
    );

    final _footerBtns = Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildList(context, this.listPhase),
        ],
      ),
    );

    final secondSection = Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        height: screenHeight * 0.33,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Column(children: <Widget>[
              _distance,
              _description,
              _openingHours,
            ]),
            Column(
              children: <Widget>[
                _footerBtns,
              ],
            )
          ],
        )),
      ),
    );

    return secondSection;
  }

  Widget buildList(BuildContext context, List<UserCultivationPhaseModel> list) {
    List<UserCultivationPhaseModel> leftSide = [];
    List<UserCultivationPhaseModel> rightSide = [];
    list.forEach((publication) {
      int index = list.indexOf(publication);
      bool isOddNum = isOddNumber(index);
      isOddNum ? rightSide.add(publication) : leftSide.add(publication);
    });
    return widget.publication.isChecked
        ? Row(
            children: <Widget>[
              Center(
                child: Text(widget.publication.description),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: rightSide
                    .map((res) => _buildIconCard(context, res))
                    .toList(),
              ),
              Column(
                children: leftSide
                    .map((res) => _buildIconCard(context, res))
                    .toList(),
              ),
            ],
          );
  }

  bool isOddNumber(int number) {
    return number % 2 == 0 ? true : false;
  }

  Widget _buildIconCard(BuildContext context, UserCultivationPhaseModel phase) {
    return GestureDetector(
        onTap: () {
          print("Container was tapped");
          Navigator.pushNamed(
            context,
            NavigatorToPath.PhaseDetail,
            arguments: this.listPhase,
          );
          GetIt.I<InitServices>().authService.temporalpub = widget.publication;
        },
        child: Container(
          child: Column(
            children: <Widget>[
              Image.network(phase.image, height: 70.0, width: 70.0),
              SizedBox(
                height: 3.0,
              ),
              Text(
                phase.name,
                style: TextStyle(color: Color(0xFFACE3EE)),
              )
            ],
          ),
        ));
  }
}
