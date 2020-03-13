import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reversi',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Reversi'),
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

  List<List<Container>> _board;

  @override
  void initState() {
    super.initState();

    _resetBoard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          ..._generatePlayground(),
          Spacer(),
          Row(
            children: <Widget>[
              _buildScore(true),
              _buildScore(false),
            ],
          )
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
              GestureDetector(
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

  Widget _buildScore(bool isFirstPersonTurn) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18.0,
          horizontal: 32.0,
        ),
        color: isFirstPersonTurn ? Colors.grey.shade400 : Colors.blueGrey,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildBlockUnit(
              isFirstPersonTurn,
              size: 16.0,
            ),
            Text(
              ' x ${_getScore(isFirstPersonTurn)}',
              style: TextStyle(
                color: isFirstPersonTurn ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RaisedButton(
            elevation: 0.0,
            color: Colors.green,
            child: Text(
              'RESTART GAME',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
            onPressed: _resetBoard,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Row(
              children: <Widget>[
                Text(
                  'TURN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(width: 8.0),
                _buildBlockUnit(
                  _isFirstPersonTurn,
                  size: 16.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _calculateMoves(int row, int column) {
    if (_isEmpty(row, column)) {
      bool updateState = false;

      if (_validateTop(row, column)) {
        _changeTopColor(row, column, false);

        updateState = true;
      }

      if (_validateBottom(row, column)) {
        _changeButtomColor(row, column, false);

        updateState = true;
      }

      if (_validateLeft(row, column)) {
        _changeLeftColor(row, column, false);

        updateState = true;
      }

      if (_validateRight(row, column)) {
        _changeRightColor(row, column, false);

        updateState = true;
      }

      if (_validateTopLeft(row, column)) {
        _changeTopLeftColor(row, column, false);

        updateState = true;
      }

      if (_validateTopRight(row, column)) {
        _changeTopRightColor(row, column, false);

        updateState = true;
      }

      if (_validateBottomLeft(row, column)) {
        _changeBottomLeftColor(row, column, false);

        updateState = true;
      }

      if (_validateBottomRight(row, column)) {
        _changeBottomRightColor(row, column, false);

        updateState = true;
      }

      if (updateState) {
        setState(() => _isFirstPersonTurn = !_isFirstPersonTurn);

        if (!_isFirstPersonTurn) {
          Future.delayed(
            Duration(milliseconds: 500),
            () => _selectBestCuttentChoise(),
          );
        }
      }
    }
  }

  static Widget _buildBlockUnit(bool isFirstPersonTurn, {double size = 32.0}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
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

  bool _validateTopLeft(int row, int column) {
    if (row - 2 < 0 || column - 2 < 0) {
      return false;
    }

    if (_board[row - 1][column - 1] == null) {
      return false;
    }

    if ((_board[row - 1][column - 1]?.decoration as BoxDecoration).color ==
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      return false;
    }

    while (row - 2 >= 0 && column - 2 >= 0) {
      Container child = _board[row - 2][column - 2];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isFirstPersonTurn ? Colors.black : Colors.white)) {
        return true;
      }

      row--;
      column--;
    }

    return false;
  }

  bool _validateTopRight(int row, int column) {
    if (row - 2 < 0 || column + 2 > 7) {
      return false;
    }

    if (_board[row - 1][column + 1] == null) {
      return false;
    }

    if ((_board[row - 1][column + 1]?.decoration as BoxDecoration).color ==
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      return false;
    }

    while (row - 2 >= 0 && column + 2 <= 7) {
      Container child = _board[row - 2][column + 2];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isFirstPersonTurn ? Colors.black : Colors.white)) {
        return true;
      }

      row--;
      column++;
    }

    return false;
  }

  bool _validateBottomLeft(int row, int column) {
    if (row + 2 > 7 || column - 2 < 0) {
      return false;
    }

    if (_board[row + 1][column - 1] == null) {
      return false;
    }

    if ((_board[row + 1][column - 1]?.decoration as BoxDecoration).color ==
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      return false;
    }

    while (row + 2 <= 7 && column - 2 >= 0) {
      Container child = _board[row + 2][column - 2];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isFirstPersonTurn ? Colors.black : Colors.white)) {
        return true;
      }

      row++;
      column--;
    }

    return false;
  }

  bool _validateBottomRight(int row, int column) {
    if (row + 2 > 7 || column + 2 > 7) {
      return false;
    }

    if (_board[row + 1][column + 1] == null) {
      return false;
    }

    if ((_board[row + 1][column + 1]?.decoration as BoxDecoration).color ==
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      return false;
    }

    while (row + 2 <= 7 && column + 2 <= 7) {
      Container child = _board[row + 2][column + 2];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isFirstPersonTurn ? Colors.black : Colors.white)) {
        return true;
      }

      row++;
      column++;
    }

    return false;
  }

  int _changeTopColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }

    while ((_board[--row][column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
      }

      count++;
    }

    return count;
  }

  int _changeButtomColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }

    while ((_board[++row][column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
      }

      count++;
    }

    return count;
  }

  int _changeLeftColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }

    while ((_board[row][--column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
      }

      count++;
    }

    return count;
  }

  int _changeRightColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }

    while ((_board[row][++column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
      }

      count++;
    }

    return count;
  }

  int _changeTopLeftColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }

    while ((_board[--row][--column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
      }

      count++;
    }

    return count;
  }

  int _changeTopRightColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }

    while ((_board[--row][++column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
      }

      count++;
    }

    return count;
  }

  int _changeBottomLeftColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }

    while ((_board[++row][--column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
      }

      count++;
    }

    return count;
  }

  int _changeBottomRightColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
    }

    while ((_board[++row][++column].decoration as BoxDecoration).color !=
        (_isFirstPersonTurn ? Colors.black : Colors.white)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isFirstPersonTurn);
      }

      count++;
    }

    return count;
  }

  int _getScore(bool isFirstPlayer) {
    int score = 0;

    for (int row = 0; row < 8; row++) {
      for (int column = 0; column < 8; column++) {
        if (_board[row][column] != null &&
            (_board[row][column].decoration as BoxDecoration).color ==
                (isFirstPlayer ? Colors.black : Colors.white)) score++;
      }
    }

    return score;
  }

  void _resetBoard() {
    _board = List.generate(
      8,
      (int row) => List.generate(
        8,
        (int column) => row == 3 && column == 3
            ? _buildBlockUnit(false)
            : row == 3 && column == 4
                ? _buildBlockUnit(true)
                : row == 4 && column == 3
                    ? _buildBlockUnit(true)
                    : row == 4 && column == 4 ? _buildBlockUnit(false) : null,
      ),
    );

    _isFirstPersonTurn = true;

    setState(() {});
  }

  List<List<int>> _getChoises() {
    List<List<int>> scores = List.generate(
      8,
      (int row) => List.generate(
        8,
        (int column) => 0,
      ),
    );

    for (int row = 0; row < 8; row++) {
      for (int column = 0; column < 8; column++) {
        if (_isEmpty(row, column)) {
          int score = 0;

          if (_validateTop(row, column)) {
            score = _changeTopColor(row, column, true);
          }

          if (_validateBottom(row, column)) {
            score = _changeButtomColor(row, column, true);
          }

          if (_validateLeft(row, column)) {
            score = _changeLeftColor(row, column, true);
          }

          if (_validateRight(row, column)) {
            score = _changeRightColor(row, column, true);
          }

          if (_validateTopLeft(row, column)) {
            score = _changeTopLeftColor(row, column, true);
          }

          if (_validateTopRight(row, column)) {
            score = _changeTopRightColor(row, column, true);
          }

          if (_validateBottomLeft(row, column)) {
            score = _changeBottomLeftColor(row, column, true);
          }

          if (_validateBottomRight(row, column)) {
            score = _changeBottomRightColor(row, column, true);
          }

          scores[row][column] = score;
        }
      }
    }

    return scores;
  }

  void _selectBestCuttentChoise() {
    List<List<int>> scores = _getChoises();
    List<Position> positions = [];
    Position selectedPosition;

    for (int row = 0; row < 8; row++) {
      for (int column = 0; column < 8; column++) {
        if (scores[row][column] > 0) {
          positions.add(Position(row, column, scores[row][column]));
        }
      }
    }

    positions.sort(
      (Position first, Position second) => second.score.compareTo(first.score),
    );

    if (positions.isNotEmpty) {
      selectedPosition =
          positions[math.Random().nextInt(math.min(positions.length, 3))];

      _calculateMoves(selectedPosition.row, selectedPosition.column);
    }
  }
}

class Position {
  final int row;
  final int column;
  final int score;

  Position(this.row, this.column, this.score);
}
