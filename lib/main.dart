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
  static bool _isFirstPersonTurn = true;
  static Color _backgroundColor = Colors.green;

  final List<List<Container>> _board = List.generate(
    8,
    (int row) => List.generate(
      8,
      (column) => row == 3 && column == 3
          ? _buildBlockUnit(false)
          : row == 3 && column == 4
              ? _buildBlockUnit(true)
              : row == 4 && column == 3
                  ? _buildBlockUnit(true)
                  : row == 4 && column == 4 ? _buildBlockUnit(false) : null,
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Current Player ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _buildBlockUnit(
                      _isFirstPersonTurn,
                      size: 16.0,
                    ),
                  ),
                ],
              ),
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
    double size = 32.0;

    for (int row = 0; row < 8; row++) {
      List<Widget> children = List<Widget>();

      for (int column = 0; column < 8; column++) {
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
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: _board[row][column],
                  ),
                ),
                onTap: () => _calculateMoves(row, column),
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

  void _calculateMoves(int row, int column) {
    if (_isEmpty(row, column)) {
      bool updateState = false;

      if (_validateTop(row, column)) {
        _changeTopColor(row, column);

        updateState = true;
      }

      if (_validateBottom(row, column)) {
        _changeButtomColor(row, column);

        updateState = true;
      }

      if (_validateLeft(row, column)) {
        _changeLeftColor(row, column);

        updateState = true;
      }

      if (_validateRight(row, column)) {
        _changeRightColor(row, column);

        updateState = true;
      }

      if (updateState) {
        setState(() => _isFirstPersonTurn = !_isFirstPersonTurn);
      }
    }
  }

  static Widget _buildBlockUnit(bool isFirstPersonTurn, {double size = 32.0}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: isFirstPersonTurn ? Colors.black : Colors.white,
      ),
    );
  }

  bool _isEmpty(int row, int column) => _board[row][column] == null;

  bool _validateTop(int row, int column) {
    if (row - 2 < 0) {
      return false;
    }

    if (_board[row - 1][column] == null) {
      return false;
    }

    if ((_board[row - 1][column]?.decoration as BoxDecoration).color ==
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      return false;
    }

    for (int i = row - 2; i >= 0; i--) {
      Container child = _board[i][column];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isFirstPersonTurn ? Colors.black : Colors.white)) {
        return true;
      }
    }

    return false;
  }

  bool _validateBottom(int row, int column) {
    if (row + 2 > 7) {
      return false;
    }

    if (_board[row + 1][column] == null) {
      return false;
    }

    if ((_board[row + 1][column]?.decoration as BoxDecoration).color ==
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      return false;
    }

    for (int i = row + 2; i < 8; i++) {
      Container child = _board[i][column];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isFirstPersonTurn ? Colors.black : Colors.white)) {
        return true;
      }
    }

    return false;
  }

  bool _validateLeft(int row, int column) {
    if (column - 2 < 0) {
      return false;
    }

    if (_board[row][column - 1] == null) {
      return false;
    }

    if ((_board[row][column - 1]?.decoration as BoxDecoration).color ==
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      return false;
    }

    for (int i = column - 2; i >= 0; i--) {
      Container child = _board[row][i];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isFirstPersonTurn ? Colors.black : Colors.white)) {
        return true;
      }
    }

    return false;
  }

  bool _validateRight(int row, int column) {
    if (column + 2 > 7) {
      return false;
    }

    if (_board[row][column + 1] == null) {
      return false;
    }

    if ((_board[row][column + 1]?.decoration as BoxDecoration).color ==
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      return false;
    }

    for (int i = column + 2; i < 8; i++) {
      Container child = _board[row][i];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isFirstPersonTurn ? Colors.black : Colors.white)) {
        return true;
      }
    }

    return false;
  }

  void _changeTopColor(int row, int column) {
    _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);

    while ((_board[--row][column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }
  }

  void _changeButtomColor(int row, int column) {
    _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);

    while ((_board[++row][column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }
  }

  void _changeLeftColor(int row, int column) {
    _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);

    while ((_board[row][--column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }
  }

  void _changeRightColor(int row, int column) {
    _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);

    while ((_board[row][++column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }
  }
}
