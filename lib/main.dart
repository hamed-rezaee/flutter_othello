import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(App());

const int BOARD_SIZE = 8;

const Color PLAYER_COLOR = Colors.black;
const Color AI_COLOR = Colors.white;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reversi',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.green,
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(title: 'Reversi'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _blocSize;
  bool _isPlayerTurn = true;

  List<List<Container>> _board;

  @override
  void initState() {
    super.initState();

    _resetBoard();
  }

  @override
  Widget build(BuildContext context) {
    _blocSize =
        (MediaQuery.of(context).size.width - BOARD_SIZE * 5) / BOARD_SIZE;

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
    List<Widget> playground = List<Widget>();

    for (int row = 0; row < BOARD_SIZE; row++) {
      List<Widget> children = List<Widget>();

      for (int column = 0; column < BOARD_SIZE; column++) {
        children.add(
          Row(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: _blocSize,
                  height: _blocSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _board[row][column],
                  ),
                ),
                onTap: () => _calculateChanges(row: row, column: column),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 2.0),
              ),
            ],
          ),
        );
      }

      playground.add(
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

    return playground;
  }

  Widget _buildScore(bool isPlayerTurn) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 18.0,
          horizontal: 32.0,
        ),
        color: isPlayerTurn ? Colors.grey.shade400 : Colors.blueGrey,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildBlockUnit(
              isPlayerTurn,
              size: 16.0,
            ),
            Text(
              ' x ${_getScore(isPlayerTurn)}',
              style: TextStyle(
                color: isPlayerTurn ? PLAYER_COLOR : AI_COLOR,
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
            color: Theme.of(context).accentColor,
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
            padding:
                const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0),
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
                  _isPlayerTurn,
                  size: 16.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildBlockUnit(bool isPlayerTurn, {double size = 32.0}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((BOARD_SIZE * 4).toDouble()),
        color: isPlayerTurn ? PLAYER_COLOR : AI_COLOR,
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
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      return false;
    }

    for (int i = row - 2; i >= 0; i--) {
      Container child = _board[i][column];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
        return true;
      }
    }

    return false;
  }

  bool _validateBottom(int row, int column) {
    if (row + 2 > BOARD_SIZE - 1) {
      return false;
    }

    if (_board[row + 1][column] == null) {
      return false;
    }

    if ((_board[row + 1][column]?.decoration as BoxDecoration).color ==
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      return false;
    }

    for (int i = row + 2; i < BOARD_SIZE; i++) {
      Container child = _board[i][column];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
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
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      return false;
    }

    for (int i = column - 2; i >= 0; i--) {
      Container child = _board[row][i];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
        return true;
      }
    }

    return false;
  }

  bool _validateRight(int row, int column) {
    if (column + 2 > BOARD_SIZE - 1) {
      return false;
    }

    if (_board[row][column + 1] == null) {
      return false;
    }

    if ((_board[row][column + 1]?.decoration as BoxDecoration).color ==
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      return false;
    }

    for (int i = column + 2; i < BOARD_SIZE; i++) {
      Container child = _board[row][i];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
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
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      return false;
    }

    while (row - 2 >= 0 && column - 2 >= 0) {
      Container child = _board[row - 2][column - 2];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
        return true;
      }

      row--;
      column--;
    }

    return false;
  }

  bool _validateTopRight(int row, int column) {
    if (row - 2 < 0 || column + 2 > BOARD_SIZE - 1) {
      return false;
    }

    if (_board[row - 1][column + 1] == null) {
      return false;
    }

    if ((_board[row - 1][column + 1]?.decoration as BoxDecoration).color ==
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      return false;
    }

    while (row - 2 >= 0 && column + 2 <= BOARD_SIZE - 1) {
      Container child = _board[row - 2][column + 2];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
        return true;
      }

      row--;
      column++;
    }

    return false;
  }

  bool _validateBottomLeft(int row, int column) {
    if (row + 2 > BOARD_SIZE - 1 || column - 2 < 0) {
      return false;
    }

    if (_board[row + 1][column - 1] == null) {
      return false;
    }

    if ((_board[row + 1][column - 1]?.decoration as BoxDecoration).color ==
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      return false;
    }

    while (row + 2 <= BOARD_SIZE - 1 && column - 2 >= 0) {
      Container child = _board[row + 2][column - 2];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
        return true;
      }

      row++;
      column--;
    }

    return false;
  }

  bool _validateBottomRight(int row, int column) {
    if (row + 2 > BOARD_SIZE - 1 || column + 2 > BOARD_SIZE - 1) {
      return false;
    }

    if (_board[row + 1][column + 1] == null) {
      return false;
    }

    if ((_board[row + 1][column + 1]?.decoration as BoxDecoration).color ==
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      return false;
    }

    while (row + 2 <= BOARD_SIZE - 1 && column + 2 <= BOARD_SIZE - 1) {
      Container child = _board[row + 2][column + 2];

      if (child == null) {
        return false;
      }

      if ((child.decoration as BoxDecoration).color ==
          (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
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
      _board[row][column] = _buildBlockUnit(_isPlayerTurn);
    }

    while ((_board[--row][column].decoration as BoxDecoration).color !=
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isPlayerTurn);
      }

      count++;
    }

    return count;
  }

  int _changeButtomColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isPlayerTurn);
    }

    while ((_board[++row][column].decoration as BoxDecoration).color !=
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isPlayerTurn);
      }

      count++;
    }

    return count;
  }

  int _changeLeftColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isPlayerTurn);
    }

    while ((_board[row][--column].decoration as BoxDecoration).color !=
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isPlayerTurn);
      }

      count++;
    }

    return count;
  }

  int _changeRightColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isPlayerTurn);
    }

    while ((_board[row][++column].decoration as BoxDecoration).color !=
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isPlayerTurn);
      }

      count++;
    }

    return count;
  }

  int _changeTopLeftColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isPlayerTurn);
    }

    while ((_board[--row][--column].decoration as BoxDecoration).color !=
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isPlayerTurn);
      }

      count++;
    }

    return count;
  }

  int _changeTopRightColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isPlayerTurn);
    }

    while ((_board[--row][++column].decoration as BoxDecoration).color !=
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isPlayerTurn);
      }

      count++;
    }

    return count;
  }

  int _changeBottomLeftColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isPlayerTurn);
    }

    while ((_board[++row][--column].decoration as BoxDecoration).color !=
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isPlayerTurn);
      }

      count++;
    }

    return count;
  }

  int _changeBottomRightColor(int row, int column, bool getCountOnly) {
    int count = 1;

    if (!getCountOnly) {
      _board[row][column] = _buildBlockUnit(_isPlayerTurn);
    }

    while ((_board[++row][++column].decoration as BoxDecoration).color !=
        (_isPlayerTurn ? PLAYER_COLOR : AI_COLOR)) {
      if (!getCountOnly) {
        _board[row][column] = _buildBlockUnit(_isPlayerTurn);
      }

      count++;
    }

    return count;
  }

  int _getScore(bool isFirstPlayer) {
    int score = 0;

    for (int row = 0; row < BOARD_SIZE; row++) {
      for (int column = 0; column < BOARD_SIZE; column++) {
        if (_board[row][column] != null &&
            (_board[row][column].decoration as BoxDecoration).color ==
                (isFirstPlayer ? PLAYER_COLOR : AI_COLOR)) score++;
      }
    }

    return score;
  }

  void _resetBoard() {
    _board = List.generate(
      BOARD_SIZE,
      (int row) => List.generate(
        BOARD_SIZE,
        (int column) =>
            row == BOARD_SIZE / 2 - 1 && column == BOARD_SIZE / 2 - 1
                ? _buildBlockUnit(false)
                : row == BOARD_SIZE / 2 - 1 && column == BOARD_SIZE / 2
                    ? _buildBlockUnit(true)
                    : row == BOARD_SIZE / 2 && column == BOARD_SIZE / 2 - 1
                        ? _buildBlockUnit(true)
                        : row == BOARD_SIZE / 2 && column == BOARD_SIZE / 2
                            ? _buildBlockUnit(false)
                            : null,
      ),
    );

    _isPlayerTurn = true;

    setState(() {});
  }

  List<List<int>> _getPositionsInformation() {
    List<List<int>> scores = List.generate(
      BOARD_SIZE,
      (int row) => List.generate(
        BOARD_SIZE,
        (int column) => 0,
      ),
    );

    for (int row = 0; row < BOARD_SIZE; row++) {
      for (int column = 0; column < BOARD_SIZE; column++) {
        if (_isEmpty(row, column)) {
          scores[row][column] = _getPositionScore(row, column, true);
        }
      }
    }

    return scores;
  }

  List<PositionInformation> _getAvailablePositions() {
    List<List<int>> scores = _getPositionsInformation();
    List<PositionInformation> availablePositions = [];

    for (int row = 0; row < BOARD_SIZE; row++) {
      for (int column = 0; column < BOARD_SIZE; column++) {
        if (scores[row][column] > 0) {
          availablePositions
              .add(PositionInformation(row, column, scores[row][column]));
        }
      }
    }

    return availablePositions;
  }

  void _selectGoodPosition() {
    List<PositionInformation> positions = _getAvailablePositions();

    if (positions.isEmpty) {
      _calculateChanges(hasNoAvailablePosition: true);
    } else {
      List<PositionInformation> corners = [];
      PositionInformation selectedPosition;

      for (PositionInformation position in positions) {
        if (position.row == 0 && position.column == 0) {
          corners.add(position);
        } else if (position.row == 0 && position.column == BOARD_SIZE - 1) {
          corners.add(position);
        } else if (position.row == BOARD_SIZE - 1 && position.column == 0) {
          corners.add(position);
        } else if (position.row == BOARD_SIZE - 1 &&
            position.column == BOARD_SIZE - 1) {
          corners.add(position);
        }
      }

      if (corners.isNotEmpty) {
        selectedPosition = positions[math.Random().nextInt(corners.length)];
      } else if (positions.isNotEmpty) {
        positions.sort(
          (PositionInformation first, PositionInformation second) =>
              second.score.compareTo(first.score),
        );

        selectedPosition =
            positions[math.Random().nextInt(math.min(positions.length, 3))];
      }

      _calculateChanges(
        row: selectedPosition.row,
        column: selectedPosition.column,
      );
    }
  }

  Future<void> _calculateChanges({
    int row,
    int column,
    bool hasNoAvailablePosition = false,
  }) async {
    if (hasNoAvailablePosition || _getAvailablePositions().isEmpty) {
      await Future.delayed(
        Duration(milliseconds: 500),
        () => setState(() => _isPlayerTurn = !_isPlayerTurn),
      );
    } else {
      if (_isEmpty(row, column)) {
        bool updateState = _getPositionScore(row, column, false) > 0;

        if (updateState) {
          setState(() => _isPlayerTurn = !_isPlayerTurn);

          if (!_isPlayerTurn) {
            await Future.delayed(
              Duration(milliseconds: 500),
              () => _selectGoodPosition(),
            );
          }
        }
      }
    }

    await Future.delayed(Duration(milliseconds: 500), () {
      if (_getScore(true) + _getScore(false) == BOARD_SIZE * BOARD_SIZE) {
        _showFinishedGameDialog();
      }
    });
  }

  int _getPositionScore(int row, int column, getCountOnly) {
    int score = 0;

    if (_validateTop(row, column)) {
      score = _changeTopColor(row, column, getCountOnly);
    }

    if (_validateBottom(row, column)) {
      score = _changeButtomColor(row, column, getCountOnly);
    }

    if (_validateLeft(row, column)) {
      score = _changeLeftColor(row, column, getCountOnly);
    }

    if (_validateRight(row, column)) {
      score = _changeRightColor(row, column, getCountOnly);
    }

    if (_validateTopLeft(row, column)) {
      score = _changeTopLeftColor(row, column, getCountOnly);
    }

    if (_validateTopRight(row, column)) {
      score = _changeTopRightColor(row, column, getCountOnly);
    }

    if (_validateBottomLeft(row, column)) {
      score = _changeBottomLeftColor(row, column, getCountOnly);
    }

    if (_validateBottomRight(row, column)) {
      score = _changeBottomRightColor(row, column, getCountOnly);
    }

    return score;
  }

  Future<void> _showFinishedGameDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      child: AlertDialog(
        content: Text(
          _getScore(true) > _getScore(false) ? 'YOU WIN!' : 'AI WINS!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('RESTART GAME'),
            onPressed: () {
              _resetBoard();

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class PositionInformation {
  final int row;
  final int column;
  final int score;

  PositionInformation(this.row, this.column, this.score);
}
