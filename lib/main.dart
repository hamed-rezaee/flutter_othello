import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isFirstPersonTurn = true;

  static Color _backgroundColor = Colors.green;

  final List<List<Widget>> _isSelected = List.generate(
    8,
    (int row) => List.generate(
      8,
      (column) => Center(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 24.0),
            height: 90.0,
            color: Colors.redAccent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Player',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                _buildBlockUnit(_isFirstPersonTurn, 32.0),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          ..._generatePlayground()
        ],
      ),
    );
  }

  List<Widget> _generatePlayground() {
    List<Widget> result = List<Widget>();
    double size = MediaQuery.of(context).size.width / 8 - 4;

    for (int i = 0; i < 8; i++) {
      List<Widget> children = List<Widget>();

      for (int j = 0; j < 8; j++) {
        children.add(
          Row(
            children: <Widget>[
              InkWell(
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: _isSelected[i][j],
                ),
                onTap: () => _changeChild(i, j),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 2.0),
              ),
            ],
          ),
        );
      }

      result.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      );
    }

    return result;
  }

  void _changeChild(int row, int column) {
    double size = MediaQuery.of(context).size.width / 8;

    if (_isSelected[row][column] is Center) {
      _isSelected[row][column] = _buildBlockUnit(_isFirstPersonTurn, size);
      _isFirstPersonTurn = !_isFirstPersonTurn;

      setState(() {});
    }
  }

  Widget _buildBlockUnit(bool isFirstPersonTurn, double size) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _isFirstPersonTurn ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
