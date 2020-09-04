import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:huerto_app/src/bloc/cultivation_phase_bloc.dart';
import 'package:huerto_app/src/models/user_cultivation_phase_model.dart';
import 'package:huerto_app/src/services/init_services.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:huerto_app/src/widgets/shared/template_popup.dart';
import 'package:huerto_app/utils/utils.dart';

class OnPhaseScreen extends StatefulWidget {
  final List<UserCultivationPhaseModel> listPhase;
  final int idActualPhase;
  OnPhaseScreen({@required this.listPhase, this.idActualPhase});

  @override
  _OnPhaseScreenState createState() => _OnPhaseScreenState();
}

class _OnPhaseScreenState extends State<OnPhaseScreen> {
  String _phone;
  final kTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 26.0,
    height: 1.5,
  );
  int _numPages;
  PageController _pageController;
  int _currentPage;
  CultivationPhaseBloc phasebloc;
  @override
  void initState() {
    this.phasebloc = CultivationPhaseBloc(-1);
    this._numPages = widget.listPhase.length;
    this._currentPage = getCurrentPage();
    this._pageController = PageController(initialPage: this._currentPage);

    super.initState();
  }

  int getCurrentPage() {
    int currentpage = -1;
    for (var index = 0; index < this.widget.listPhase.length; index++) {
      if (this.widget.listPhase[index].statePhase) {
        currentpage = index;
      }
    }
    return currentpage;
  }

  final kSubtitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    height: 1.2,
  );

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(microseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xFF7B51D3),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                0.1,
                0.4,
                0.7,
                0.9
              ],
                  colors: [
                Color(0xFF3594DD),
                Color(0xFF4569DB),
                Color(0xFF5036D5),
                Color(0xFF5B16D0)
              ])),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 600.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: _buildPadingPhase(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    'Regresar',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24.0),
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    if (widget.listPhase[this._currentPage]
                                        .statePhase) {
                                      widget.listPhase[this._currentPage]
                                          .statePhase = false;
                                      widget.listPhase[this._currentPage + 1]
                                          .statePhase = true;

                                      this.phasebloc.updatePhaseStatus(
                                          false,
                                          DateTime.now(),
                                          widget
                                              .listPhase[this._currentPage].id,
                                          widget
                                              .listPhase[this._currentPage + 1]
                                              .id);
                                    }

                                    _pageController.nextPage(
                                        duration: Duration(microseconds: 300),
                                        curve: Curves.easeIn);
                                  },
                                  child: Text(
                                    widget.listPhase[this._currentPage]
                                            .statePhase
                                        ? 'Terminar Fase '
                                        : 'Siguiente',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 80.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () {
                  if (widget.listPhase[this._currentPage].statePhase) {
                    final popup = BeautifulPopup.customize(
                      context: context,
                      build: (options) => MyTemplatePopup(options),
                    );
                    popup.recolor(Color(0xFF5B16D0));
                    popup.show(
                      title: 'Publicar Producto',
                      content: Container(
                          child: Column(
                        children: <Widget>[
                          Text('TESX.'),
                          _textphone(),
                        ],
                      )),
                      actions: [
                        popup.button(
                          label: 'Actualizar',
                          onPressed: () {
                            phasebloc.updatePublication(
                                phasebloc.controller.text,
                                GetIt.I<InitServices>()
                                    .authService
                                    .temporalpub
                                    .id,
                                GetIt.I<InitServices>()
                                    .authService
                                    .userLogin
                                    .id);

                            Navigator.of(context).pop();

                            Navigator.pop(context);
                          },
                        ),
                      ],
                      close: Container(),
                      barrierDismissible: true,
                    );
                    notificationFinish();
                  } else {
                    print('No se puede Publicar ' +
                        widget.listPhase.length.toString());
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.listPhase[this._currentPage].statePhase
                            ? 'Publicar'
                            : "Completa todas las Fases",
                        style: TextStyle(
                            color: Color(0xFF5B16D0),
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10.0),
                      Icon(
                        widget.listPhase[this._currentPage].statePhase
                            ? Icons.arrow_forward
                            : Icons.warning,
                        color: Color(0xFF5B16D0),
                        size: 30.0,
                      )
                    ],
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }

  List<SingleChildScrollView> _buildPadingPhase() {
    List<SingleChildScrollView> list = new List<SingleChildScrollView>();
    widget.listPhase.forEach((element) {
      list.add(
        SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  element.statePhase
                      ? "Fase Actual: " + element.name
                      : element.level.toString() + ". " + element.name,
                  style: kTitleStyle,
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: Image(
                  image: NetworkImage(element.image),
                  height: 200.0,
                  width: 200.0,
                ),
              ),
              SizedBox(height: 30.0),
              Text(
                element.description,
                style: kSubtitleStyle,
              ),
              Text(
                element.steps,
                style: kSubtitleStyle,
              ),
            ],
          ),
        ),
      );
    });

    return list;
  }

  TextFormField _textphone() {
    return TextFormField(
      keyboardType: TextInputType.number,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      validator: (input) {
        return input.length < 10 ?? 'Ingresa un numero telefonico';
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF5B16D0)),
              borderRadius: BorderRadius.circular(30)),
          contentPadding: EdgeInsets.all(15),
          suffixIcon: Icon(
            Icons.phone,
            color: Colors.white,
          ),
          filled: true,
          fillColor: Color(0xFF5036D5),
          focusColor: Color(0xFF5036D5),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(30)),
          hintStyle: TextStyle(color: Colors.white),
          hintText: 'Telefono'),
      controller: phasebloc.controller,
    );
  }

  void notificationFinish() {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateGift,
    );
    popup.show(
      title: 'Felicidades ',
      content: 'Tu cultivo se ha publicado con exito ',
      actions: [
        popup.button(
          label: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      ],
      // bool barrierDismissible = false,
      // Widget close,
    );
  }
}
