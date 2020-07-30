import 'package:flutter/material.dart';
import 'package:huerto_app/src/models/publication_model.dart';
import 'package:huerto_app/src/widgets/home/review_card.dart';

import 'package:huerto_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:huerto_app/src/routes/router.dart';
import 'package:huerto_app/src/models/review.dart';

class AccountPage extends StatefulWidget {
  final Stream<List<PublicationModel>> publicationStream;

  AccountPage(this.publicationStream);
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  FirebaseUser user;

  getUser() async {
    FirebaseUser firebaseUser =
        await GetIt.I<InitServices>().authService.getUser();
    setState(() {
      this.user = firebaseUser;
    });
  }

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

  var deviceWidth, deviceHeight;
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
        child: StreamBuilder<List<PublicationModel>>(
      stream: this.widget.publicationStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          print(snapshot);
          return Center(child: CircularProgressIndicator());
        } else {}
        return Column(
          children: <Widget>[
            _buildUserImageSection(),
            _buildReviewsSection(snapshot.data)
          ],
        );
      },
    ));
  }

  Container _buildUserImageSection() {
    final userImage = Positioned(
      top: deviceHeight * 0.09,
      left: deviceWidth * 0.28,
      child: Container(
        height: 180.0,
        width: 180.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AvailableImages.logo),
            fit: BoxFit.cover,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );

    final circle1 = Positioned(
      top: deviceHeight * 0.09,
      right: deviceWidth * 0.18,
      child: _buildGradientCircle(90.0),
    );
    final circle2 = Positioned(
      top: deviceHeight * 0.17,
      left: deviceWidth * 0.13,
      child: _buildGradientCircle(70.0),
    );
    final circle3 = Positioned(
      top: deviceHeight * 0.29,
      right: deviceWidth * 0.33,
      child: _buildGradientCircle(40.0),
    );

    final userNameAndLocation = Positioned(
      top: deviceHeight * 0.33,
      left: 0,
      right: 0,
      child: Column(
        children: <Widget>[
          Text(
            "Hola",
            style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w800),
          ),
          Text(
            "Bienvenido ",
            style: TextStyle(
              color: Colors.grey.withOpacity(0.9),
              fontSize: 20.0,
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: RaisedButton(
              padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              color: Colors.blue,
              onPressed: signout,
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );

    final userImageSection = Container(
      height: deviceHeight * 0.5,
      child: Stack(
        children: <Widget>[
          circle1,
          circle2,
          circle3,
          userImage,
          userNameAndLocation
        ],
      ),
    );
    return userImageSection;
  }

  Container _buildReviewsSection(List<PublicationModel> _reviews) {
    final br = Radius.circular(30.0);
    final reviewList =
        _reviews.map((review) => ReviewCard(review: review)).toList();
    final reviewsSection = Container(
      padding: EdgeInsets.only(top: 30.0, left: 30.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: br, topLeft: br),
      ),
      constraints: BoxConstraints(minHeight: deviceHeight / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Tus Trueques",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children: reviewList,
          )
        ],
      ),
    );

    return reviewsSection;
  }

  Widget _buildGradientCircle(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFECF9E8),
            Color(0xFFE6F6EF),
          ],
        ),
      ),
    );
  }
}
