import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  int numberOfSquares = 750;
  static List<int> snakePositoin = [45, 65, 85, 105, 125];

  static var randomNumbers = Random();
  int food = randomNumbers.nextInt(700);

  void startGame() {
    snakePositoin = [45, 65, 85, 105, 125];
    const duration = Duration(milliseconds: 300);
    Timer.periodic(duration, (Timer timer) {
      updateGame();
      if (gameOver()) {
        timer.cancel();
        _showGameOverModal();
      }
    });
  }

  void generateFood() {
    food = randomNumbers.nextInt(700);
  }

  void _showGameOverModal() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text("GAME OVER"),
            content: Text("Your score is ${snakePositoin.length}"),
            actions: [
              FlatButton(
                  onPressed: () {
			startGame();
                    Navigator.of(context).pop();
                  },
                  child: Text("Start again"))
            ],
          );
        });
  }

  bool gameOver() {
    for (int i = 0; i < snakePositoin.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePositoin.length; j++) {
        if (snakePositoin[i] == snakePositoin[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  var direction = "down";
  void updateGame() {
    setState(() {
      switch (direction) {
        case "down":
          if (snakePositoin.last > 740) {
            snakePositoin.add(snakePositoin.last + 20 - 760);
          } else {
            snakePositoin.add(snakePositoin.last + 20);
          }
          break;

        case "up":
          if (snakePositoin.last < 20) {
            snakePositoin.add(snakePositoin.last - 20 + 760);
          } else {
            snakePositoin.add(snakePositoin.last - 20);
          }
          break;
        case "left":
          if (snakePositoin.last % 20 == 0) {
            snakePositoin.add(snakePositoin.last - 1 + 20);
          } else {
            snakePositoin.add(snakePositoin.last - 1);
          }
          break;
        case "right":
          if ((snakePositoin.last + 1) % 20 == 0) {
            snakePositoin.add(snakePositoin.last + 1 - 20);
          } else {
            snakePositoin.add(snakePositoin.last + 1);
          }
          break;
        default:
      }

      if (snakePositoin.last == food) {
        generateFood();
      }else{
        snakePositoin.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != "up" && details.delta.dy > 0) {
                  direction = "down";
                } else if (direction != "down" && details.delta.dy < 0) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != "left" && details.delta.dx > 0) {
                  direction = "right";
                } else if (direction != "right" && details.delta.dx < 0) {
                  direction = "left";
                }
              },
              child: Container(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 20),
                    itemBuilder: (ctx, i) {
                      if (snakePositoin.contains(i)) {
                        return Center(
                            child: Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        ));
                      }
                      if (i == food) {
                        return Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: Colors.green,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: Colors.grey[900],
                            ),
                          ),
                        );
                      }
                    }),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: startGame,
                  child: Text(
                    "Start Game",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Text(
                  "Created by Reflex",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20.0,
                      letterSpacing: 5.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
