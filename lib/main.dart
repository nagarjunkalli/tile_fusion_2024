import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'support_page.dart'; // Import the new support page

void main() => runApp(const Game2048App());

class Game2048App extends StatefulWidget {
  const Game2048App({super.key});

  @override
  State<Game2048App> createState() => _Game2048AppState();
}

class _Game2048AppState extends State<Game2048App> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('theme_mode') ?? ThemeMode.system.index;
    if (mounted) {
      setState(() {
        _themeMode = ThemeMode.values[themeModeIndex];
      });
    }
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', themeMode.index);
  }

  void _toggleTheme(BuildContext context) {
    ThemeMode newThemeMode;
    final Brightness platformBrightness =
        MediaQuery.of(context).platformBrightness;

    switch (_themeMode) {
      case ThemeMode.system:
        newThemeMode = platformBrightness == Brightness.dark
            ? ThemeMode.light
            : ThemeMode.dark;
        break;
      case ThemeMode.light:
        newThemeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        newThemeMode = ThemeMode.light;
        break;
    }
    setState(() {
      _themeMode = newThemeMode;
    });
    _saveThemeMode(_themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tile Fusion 2048',
      themeMode: _themeMode,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      home: Game2048(
        onThemeToggle: _toggleTheme,
        currentThemeMode: _themeMode,
      ),
    );
  }

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.brown,
    scaffoldBackgroundColor: const Color(0xFFFAF8EF),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8F7A66),
        foregroundColor: const Color(0xFFF9F6F2),
      ),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.brown,
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A4A4A),
        foregroundColor: const Color(0xFFE5E5E5),
      ),
    ),
  );
}

class GameTheme {
  final Color backgroundColor;
  final Color gridColor;
  final Color titleColor;
  final Color scoreContainerColor;
  final Color scoreTextColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color instructionBgColor;
  final Color instructionTextColor;
  final Color dialogBgColor;
  final Map<int, Color> tileColors;
  final Map<int, Color> textColors;

  const GameTheme({
    required this.backgroundColor,
    required this.gridColor,
    required this.titleColor,
    required this.scoreContainerColor,
    required this.scoreTextColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.instructionBgColor,
    required this.instructionTextColor,
    required this.dialogBgColor,
    required this.tileColors,
    required this.textColors,
  });

  static const GameTheme light = GameTheme(
    backgroundColor: Color(0xFFFAF8EF),
    gridColor: Color(0xFFBBADA0),
    titleColor: Color(0xFF776E65),
    scoreContainerColor: Color(0xFFBBADA0),
    scoreTextColor: Color(0xFFF9F6F2),
    buttonColor: Color(0xFF8F7A66),
    buttonTextColor: Color(0xFFF9F6F2),
    instructionBgColor: Color(0xFFFFFFFF),
    instructionTextColor: Color(0xFF776E65),
    dialogBgColor: Color(0xFFFAF8EF),
    tileColors: {
      0: Color(0xFFCDC1B4),
      2: Color(0xFFEEE4DA),
      4: Color(0xFFEDE0C8),
      8: Color(0xFFF2B179),
      16: Color(0xFFF59563),
      32: Color(0xFFF67C5F),
      64: Color(0xFFF65E3B),
      128: Color(0xFFEDCF72),
      256: Color(0xFFEDCC61),
      512: Color(0xFFEDC850),
      1024: Color(0xFFEDC53F),
      2048: Color(0xFFEDC22E),
      4096: Color(0xFF7B68EE),
      8192: Color(0xFF9370DB),
    },
    textColors: {
      2: Color(0xFF776E65),
      4: Color(0xFF776E65),
      8: Color(0xFFF9F6F2),
      16: Color(0xFFF9F6F2),
      32: Color(0xFFF9F6F2),
      64: Color(0xFFF9F6F2),
      128: Color(0xFFF9F6F2),
      256: Color(0xFFF9F6F2),
      512: Color(0xFFF9F6F2),
      1024: Color(0xFFF9F6F2),
      2048: Color(0xFFF9F6F2),
      4096: Color(0xFFF9F6F2),
      8192: Color(0xFFF9F6F2),
    },
  );

  static const GameTheme dark = GameTheme(
    backgroundColor: Color(0xFF1A1A1A),
    gridColor: Color(0xFF2D2D2D),
    titleColor: Color(0xFFE5E5E5),
    scoreContainerColor: Color(0xFF2D2D2D),
    scoreTextColor: Color(0xFFE5E5E5),
    buttonColor: Color(0xFF4A4A4A),
    buttonTextColor: Color(0xFFE5E5E5),
    instructionBgColor: Color(0xFF2D2D2D),
    instructionTextColor: Color(0xFFB5B5B5),
    dialogBgColor: Color(0xFF2D2D2D),
    tileColors: {
      0: Color(0xFF3A3A3A),
      2: Color(0xFF4A4A4A),
      4: Color(0xFF5A5A5A),
      8: Color(0xFF8B6914),
      16: Color(0xFFA67C14),
      32: Color(0xFFB58900),
      64: Color(0xFFCB4B16),
      128: Color(0xFFDC8C2C),
      256: Color(0xFFE5A532),
      512: Color(0xFFEDB32C),
      1024: Color(0xFFF5C542),
      2048: Color(0xFFEAA220),
      4096: Color(0xFF9B59B6),
      8192: Color(0xFF8E44AD),
    },
    textColors: {
      2: Color(0xFFE5E5E5),
      4: Color(0xFFE5E5E5),
      8: Color(0xFFE5E5E5),
      16: Color(0xFFE5E5E5),
      32: Color(0xFFE5E5E5),
      64: Color(0xFFE5E5E5),
      128: Color(0xFFE5E5E5),
      256: Color(0xFFE5E5E5),
      512: Color(0xFFE5E5E5),
      1024: Color(0xFF1A1A1A),
      2048: Color(0xFF1A1A1A),
      4096: Color(0xFFE5E5E5),
      8192: Color(0xFFE5E5E5),
    },
  );
}

class Game2048 extends StatefulWidget {
  const Game2048(
      {super.key, required this.onThemeToggle, required this.currentThemeMode});

  final void Function(BuildContext) onThemeToggle;
  final ThemeMode currentThemeMode;

  @override
  State<Game2048> createState() => _Game2048State();
}

class TileData {
  final int value;
  final int row;
  final int col;
  final String id;
  bool isNew;
  bool isMerged;

  TileData({
    required this.value,
    required this.row,
    required this.col,
    required this.id,
    this.isNew = false,
    this.isMerged = false,
  });
}

class _Game2048State extends State<Game2048> with TickerProviderStateMixin {
  static const int size = 4;
  List<List<int>> grid = List.generate(size, (_) => List.filled(size, 0));
  List<List<int>> previousGrid =
      List.generate(size, (_) => List.filled(size, 0));
  int score = 0;
  int previousScore = 0;
  int highScore = 0;
  bool isAnimating = false;
  bool gameWon = false;
  bool gameOver = false;
  bool canUndo = false;
  bool isNewHighScore = false;

  late AnimationController _slideAnimationController;
  late AnimationController _scaleAnimationController;
  late AnimationController _newTileAnimationController;
  late AnimationController _pulseAnimationController;

  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _newTileAnimation;
  late Animation<double> _pulseAnimation;

  Set<String> newTileIds = {};
  Set<String> mergedTileIds = {};

  // Variables for responsive UI
  double _boardSize = 300.0; // Default, will be updated by LayoutBuilder
  double _tileGap = 8.0;
  double _tileContainerSize = 60.0;
  double _appBarTitleFontSize = 20.0;
  double _scoreLabelFontSize = 14.0;
  double _scoreValueFontSize = 22.0;
  double _buttonFontSize = 16.0;
  double _tileNumberBaseFontSize = 28.0;


  @override
  void initState() {
    super.initState();

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _newTileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _slideAnimationController, curve: Curves.easeOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
          parent: _scaleAnimationController, curve: Curves.easeOutBack),
    );
    _newTileAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _newTileAnimationController, curve: Curves.easeOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _initializeGame();
    _loadHighScore();
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _scaleAnimationController.dispose();
    _newTileAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  void _initializeGame() {
    _addRandomTile(animate: false);
    _addRandomTile(animate: false);
  }

  void _restartGame() {
    if (mounted) {
      setState(() {
        grid = List.generate(size, (_) => List.filled(size, 0));
        previousGrid = List.generate(size, (_) => List.filled(size, 0));
        score = 0;
        previousScore = 0;
        gameWon = false;
        gameOver = false;
        canUndo = false;
        isNewHighScore = false;
        newTileIds.clear();
        mergedTileIds.clear();
      });
    }
    _initializeGame();
    _loadHighScore();
  }

  void _addRandomTile({bool animate = true}) {
    List<Point<int>> empty = [];
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (grid[r][c] == 0) {
          empty.add(Point(r, c));
        }
      }
    }
    if (empty.isNotEmpty) {
      final pos = empty[Random().nextInt(empty.length)];
      final value = Random().nextInt(10) == 0 ? 4 : 2;
      grid[pos.x][pos.y] = value;
      if (animate) {
        if (mounted) {
          setState(() {
            newTileIds.add('${pos.x}-${pos.y}');
          });
        }
        _newTileAnimationController.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 30), () {
            _newTileAnimationController.reset();
            if (mounted) {
              setState(() {
                newTileIds.remove('${pos.x}-${pos.y}');
              });
            }
          });
        });
      }
    }
  }

  void _saveGameState() {
    previousScore = score;
    for (int r = 0; r < size; r++) {
      previousGrid[r] = List.from(grid[r]);
    }
  }

  void _undoMove() {
    if (!canUndo || isAnimating) {
      return;
    }
    if (mounted) {
      setState(() {
        score = previousScore;
        for (int r = 0; r < size; r++) {
          grid[r] = List.from(previousGrid[r]);
        }
        canUndo = false;
        newTileIds.clear();
        mergedTileIds.clear();
        if (gameOver) {
          gameOver = false;
        }
      });
    }
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        highScore = prefs.getInt('high_score') ?? 0;
      });
    }
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('high_score', highScore);
  }

  void _updateHighScore() {
    if (score > highScore) {
      if (mounted) {
        setState(() {
          highScore = score;
          isNewHighScore = true;
        });
        _pulseAnimationController.stop();
        _pulseAnimationController.value = _pulseAnimationController.lowerBound;
        _pulseAnimationController.forward().then((_) {
          if (mounted) {
            if (_pulseAnimationController.status == AnimationStatus.completed) {
              _pulseAnimationController.stop();
              _pulseAnimationController.value =
                  _pulseAnimationController.upperBound;
              _pulseAnimationController.reverse();
            }
          }
        }).catchError((error) {
          if (mounted) {
            _pulseAnimationController.stop();
            _pulseAnimationController.value =
                _pulseAnimationController.lowerBound;
          }
        });
      }
      _saveHighScore();
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) {
          setState(() {
            isNewHighScore = false;
          });
        }
      });
    }
  }

  bool _moveLeft() {
    _saveGameState();
    bool moved = false;
    if (mounted) setState(() => mergedTileIds.clear());
    for (int r = 0; r < size; r++) {
      List<int> currentRow = List.from(grid[r]);
      List<int> compactedRow = currentRow.where((val) => val != 0).toList();
      List<int> mergedRow = [];
      for (int i = 0; i < compactedRow.length; i++) {
        if (i + 1 < compactedRow.length &&
            compactedRow[i] == compactedRow[i + 1]) {
          int mergedValue = compactedRow[i] * 2;
          mergedRow.add(mergedValue);
          if (mounted) setState(() => score += mergedValue);
          mergedTileIds.add('$r-${mergedRow.length - 1}');
          if (mergedValue == 2048 && !gameWon) {
            if (mounted) setState(() => gameWon = true);
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) _showWinDialog();
            });
          }
          i++;
        } else {
          mergedRow.add(compactedRow[i]);
        }
      }
      List<int> finalRow = List.filled(size, 0);
      for (int i = 0; i < mergedRow.length; i++) {
        finalRow[i] = mergedRow[i];
      }
      for (int c = 0; c < size; c++) {
        if (grid[r][c] != finalRow[c]) {
          moved = true;
          grid[r][c] = finalRow[c];
        }
      }
    }
    return moved;
  }

  bool _moveRight() {
    _saveGameState();
    bool moved = false;
    if (mounted) setState(() => mergedTileIds.clear());
    for (int r = 0; r < size; r++) {
      List<int> currentRow = List.from(grid[r]);
      List<int> compactedRow =
          currentRow.where((val) => val != 0).toList().reversed.toList();
      List<int> mergedRow = [];
      for (int i = 0; i < compactedRow.length; i++) {
        if (i + 1 < compactedRow.length &&
            compactedRow[i] == compactedRow[i + 1]) {
          int mergedValue = compactedRow[i] * 2;
          mergedRow.add(mergedValue);
          if (mounted) setState(() => score += mergedValue);
          mergedTileIds.add('$r-${size - 1 - (mergedRow.length - 1)}');
          if (mergedValue == 2048 && !gameWon) {
            if (mounted) setState(() => gameWon = true);
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) _showWinDialog();
            });
          }
          i++;
        } else {
          mergedRow.add(compactedRow[i]);
        }
      }
      List<int> finalRow = List.filled(size, 0);
      for (int i = 0; i < mergedRow.length; i++) {
        finalRow[size - 1 - i] = mergedRow[i];
      }
      for (int c = 0; c < size; c++) {
        if (grid[r][c] != finalRow[c]) {
          moved = true;
          grid[r][c] = finalRow[c];
        }
      }
    }
    return moved;
  }

  bool _moveUp() {
    _saveGameState();
    bool moved = false;
    if (mounted) setState(() => mergedTileIds.clear());
    for (int c = 0; c < size; c++) {
      List<int> currentCol = [];
      for (int r = 0; r < size; r++) {
        currentCol.add(grid[r][c]);
      }
      List<int> compactedCol = currentCol.where((val) => val != 0).toList();
      List<int> mergedCol = [];
      for (int i = 0; i < compactedCol.length; i++) {
        if (i + 1 < compactedCol.length &&
            compactedCol[i] == compactedCol[i + 1]) {
          int mergedValue = compactedCol[i] * 2;
          mergedCol.add(mergedValue);
          if (mounted) setState(() => score += mergedValue);
          mergedTileIds.add('${mergedCol.length - 1}-$c');
          if (mergedValue == 2048 && !gameWon) {
            if (mounted) setState(() => gameWon = true);
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) _showWinDialog();
            });
          }
          i++;
        } else {
          mergedCol.add(compactedCol[i]);
        }
      }
      List<int> finalCol = List.filled(size, 0);
      for (int i = 0; i < mergedCol.length; i++) {
        finalCol[i] = mergedCol[i];
      }
      for (int r = 0; r < size; r++) {
        if (grid[r][c] != finalCol[r]) {
          moved = true;
          grid[r][c] = finalCol[r];
        }
      }
    }
    return moved;
  }

  bool _moveDown() {
    _saveGameState();
    bool moved = false;
    if (mounted) setState(() => mergedTileIds.clear());
    for (int c = 0; c < size; c++) {
      List<int> currentCol = [];
      for (int r = 0; r < size; r++) {
        currentCol.add(grid[r][c]);
      }
      List<int> compactedCol =
          currentCol.where((val) => val != 0).toList().reversed.toList();
      List<int> mergedCol = [];
      for (int i = 0; i < compactedCol.length; i++) {
        if (i + 1 < compactedCol.length &&
            compactedCol[i] == compactedCol[i + 1]) {
          int mergedValue = compactedCol[i] * 2;
          mergedCol.add(mergedValue);
          if (mounted) setState(() => score += mergedValue);
          mergedTileIds.add('${size - 1 - (mergedCol.length - 1)}-$c');
          if (mergedValue == 2048 && !gameWon) {
            if (mounted) setState(() => gameWon = true);
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) _showWinDialog();
            });
          }
          i++;
        } else {
          mergedCol.add(compactedCol[i]);
        }
      }
      List<int> finalCol = List.filled(size, 0);
      for (int i = 0; i < mergedCol.length; i++) {
        finalCol[size - 1 - i] = mergedCol[i];
      }
      for (int r = 0; r < size; r++) {
        if (grid[r][c] != finalCol[r]) {
          moved = true;
          grid[r][c] = finalCol[r];
        }
      }
    }
    return moved;
  }

  bool _isGameOver() {
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (grid[r][c] == 0) return false;
        if (r < size - 1 && grid[r][c] == grid[r + 1][c]) return false;
        if (c < size - 1 && grid[r][c] == grid[r][c + 1]) return false;
      }
    }
    return true;
  }

  void _handleSwipe(DragEndDetails details) {
    if (isAnimating || gameOver) return;

    bool moved = false;
    final velocity = details.velocity.pixelsPerSecond;
    const double minVelocity = 100.0;
    const double directionalThresholdFactor = 1.5;

    if (velocity.dx.abs() < minVelocity && velocity.dy.abs() < minVelocity) {
      return;
    }

    if (velocity.dx.abs() > velocity.dy.abs() * directionalThresholdFactor) {
      if (velocity.dx > minVelocity) {
        moved = _moveRight();
      } else if (velocity.dx < -minVelocity) {
        moved = _moveLeft();
      }
    } else if (velocity.dy.abs() >
        velocity.dx.abs() * directionalThresholdFactor) {
      if (velocity.dy > minVelocity) {
        moved = _moveDown();
      } else if (velocity.dy < -minVelocity) {
        moved = _moveUp();
      }
    }

    if (moved) {
      if (mounted) {
        setState(() {
          isAnimating = true;
          canUndo = true;
        });
      }
      _slideAnimationController.forward();
      if (mergedTileIds.isNotEmpty) {
        _scaleAnimationController.forward().then((_) {
          _scaleAnimationController.reverse();
        });
      }
      Future.delayed(
          _slideAnimationController.duration ??
              const Duration(milliseconds: 80), () {
        if (mounted) {
          _slideAnimationController.reset();
          _finishMove();
        }
      });
    }
  }

  void _finishMove() {
    if (!mounted) return;
    _addRandomTile();
    if (mounted) {
      setState(() {
        isAnimating = false;
      });
    }
    _updateHighScore();
    if (_isGameOver()) {
      if (mounted) {
        setState(() {
          gameOver = true;
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && gameOver) {
            _showGameOverDialog();
          }
        });
      }
    }
  }

  void _showWinDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final gameTheme = widget.currentThemeMode == ThemeMode.dark
            ? GameTheme.dark
            : GameTheme.light;
        return AlertDialog(
          backgroundColor: gameTheme.dialogBgColor,
          title: Text('You Win!',
              style: TextStyle(
                  color: gameTheme.titleColor, fontWeight: FontWeight.bold)),
          content: Text('You reached the 2048 tile!',
              style: TextStyle(color: gameTheme.instructionTextColor)),
          actions: <Widget>[
            TextButton(
              child: Text('Keep Playing',
                  style: TextStyle(
                      color: gameTheme.buttonColor,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('New Game',
                  style: TextStyle(
                      color: gameTheme.buttonColor,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _showGameOverDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        final gameTheme = widget.currentThemeMode == ThemeMode.dark
            ? GameTheme.dark
            : GameTheme.light;
        return AlertDialog(
          backgroundColor: gameTheme.dialogBgColor,
          title: Text('Game Over!',
              style: TextStyle(
                  color: gameTheme.titleColor, fontWeight: FontWeight.bold)),
          content: Text('No more moves available. Your score: $score',
              style: TextStyle(color: gameTheme.instructionTextColor)),
          actions: <Widget>[
            if (canUndo)
              ElevatedButton.icon(
                icon: Icon(Icons.undo, color: gameTheme.titleColor),
                label: const Text('Undo',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _undoMove();
                },
              ),
            ElevatedButton.icon(
              icon: Icon(Icons.refresh, color: gameTheme.titleColor),
              label: const Text('Try Again',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _restartGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _showInstructionsDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final gameTheme = widget.currentThemeMode == ThemeMode.dark
            ? GameTheme.dark
            : GameTheme.light;
        return AlertDialog(
          backgroundColor: gameTheme.dialogBgColor,
          title: Text('How to Play',
              style: TextStyle(
                  color: gameTheme.titleColor, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Swipe Up, Down, Left, or Right to move all tiles.',
                    style: TextStyle(color: gameTheme.instructionTextColor)),
                const SizedBox(height: 8),
                Text(
                    'When two tiles with the same number touch, they merge into one!',
                    style: TextStyle(color: gameTheme.instructionTextColor)),
                const SizedBox(height: 8),
                Text('Join the numbers and get to the 2048 tile!',
                    style: TextStyle(color: gameTheme.instructionTextColor)),
                const SizedBox(height: 8),
                Text(
                    'You can continue playing past 2048 to achieve an even higher score.',
                    style: TextStyle(color: gameTheme.instructionTextColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Got It!',
                  style: TextStyle(
                      color: gameTheme.buttonColor,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Helper method for tile number font size
  double _getTileNumberFontSize(int value) {
    if (value >= 10000) return _tileNumberBaseFontSize * 0.5; // e.g. 16384
    if (value >= 1000) return _tileNumberBaseFontSize * 0.6;  // e.g. 2048, 4096, 8192
    if (value >= 100) return _tileNumberBaseFontSize * 0.75; // e.g. 128, 256, 512
    return _tileNumberBaseFontSize; // e.g. 2, 4, 8, 16, 32, 64
  }


  @override
  Widget build(BuildContext context) {
    final gameTheme = widget.currentThemeMode == ThemeMode.dark
        ? GameTheme.dark
        : GameTheme.light;

    Color getTextColorForTile(int value) {
      if (value >= 8) {
        return gameTheme.textColors[8] ??
            (widget.currentThemeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black);
      }
      return gameTheme.textColors[value] ??
          (widget.currentThemeMode == ThemeMode.dark
              ? Colors.white
              : Colors.black);
    }

    return Scaffold(
      backgroundColor: gameTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Tile Fusion 2048',
            style: TextStyle(
                color: gameTheme.titleColor,
                fontWeight: FontWeight.bold,
                fontSize: _appBarTitleFontSize,
                )),
        backgroundColor: gameTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              widget.currentThemeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : widget.currentThemeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.brightness_auto,
              color: gameTheme.titleColor,
            ),
            onPressed: () => widget.onThemeToggle(context),
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: gameTheme.titleColor),
            onPressed: _showInstructionsDialog,
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, color: gameTheme.titleColor),
            tooltip: 'Support Me',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportPage()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // --- Calculate dynamic sizes ---
          double availableWidth = constraints.maxWidth - 32; // considerar padding geral do body
          double availableHeight = constraints.maxHeight - 32;

          // Estimate vertical space used by non-board elements (AppBar is separate)
          // Score displays, buttons, spacing. This is an approximation.
          // Let's say roughly 150-200 dp for scores and buttons area + top/bottom padding.
          double estimatedNonBoardHeight = 200;
          
          double heightForBoard = availableHeight - estimatedNonBoardHeight;
          if (heightForBoard < 200) heightForBoard = 200; // Min height for board area

          _boardSize = min(availableWidth, heightForBoard);
          _boardSize = _boardSize.clamp(280.0, 600.0); // Clamp board size

          _tileGap = (_boardSize * 0.03).clamp(4.0, 12.0); // 3% of board size for gap
          _tileContainerSize = (_boardSize - (size + 1) * _tileGap) / size;

          // Responsive font sizes (adjust multipliers as needed)
          _appBarTitleFontSize = (_boardSize * 0.06).clamp(18.0, 30.0);
          _scoreLabelFontSize = (_boardSize * 0.04).clamp(12.0, 18.0);
          _scoreValueFontSize = (_boardSize * 0.06).clamp(18.0, 28.0);
          _buttonFontSize = (_boardSize * 0.045).clamp(14.0, 20.0);
          _tileNumberBaseFontSize = (_tileContainerSize * 0.35).clamp(16.0, 40.0);


          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: ScoreDisplay(
                          label: 'SCORE',
                          value: score,
                          theme: gameTheme,
                          pulseAnimation: _pulseAnimation,
                          isPulsing: false,
                          labelFontSize: _scoreLabelFontSize,
                          valueFontSize: _scoreValueFontSize,
                          ),
                    ),
                    SizedBox(width: _boardSize * 0.05), // Responsive spacing
                    Expanded(
                      child: ScoreDisplay(
                          label: 'HIGH SCORE',
                          value: highScore,
                          theme: gameTheme,
                          pulseAnimation: _pulseAnimation,
                          isPulsing: isNewHighScore,
                          labelFontSize: _scoreLabelFontSize,
                          valueFontSize: _scoreValueFontSize,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: (_boardSize * 0.05).clamp(10.0, 30.0)), // Responsive spacing
                GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (gameOver) return;
                    if (details.primaryVelocity! > 200) {
                      _handleSwipe(DragEndDetails(
                          velocity: Velocity(
                              pixelsPerSecond:
                                  Offset(details.primaryVelocity!, 0))));
                    } else if (details.primaryVelocity! < -200) {
                      _handleSwipe(DragEndDetails(
                          velocity: Velocity(
                              pixelsPerSecond:
                                  Offset(details.primaryVelocity!, 0))));
                    }
                  },
                  onVerticalDragEnd: (details) {
                    if (gameOver) return;
                    if (details.primaryVelocity! > 200) {
                      _handleSwipe(DragEndDetails(
                          velocity: Velocity(
                              pixelsPerSecond:
                                  Offset(0, details.primaryVelocity!))));
                    } else if (details.primaryVelocity! < -200) {
                      _handleSwipe(DragEndDetails(
                          velocity: Velocity(
                              pixelsPerSecond:
                                  Offset(0, details.primaryVelocity!))));
                    }
                  },
                  child: Container(
                    width: _boardSize,
                    height: _boardSize,
                    padding: EdgeInsets.all((_boardSize * 0.03).clamp(6.0, 12.0)), // Responsive padding
                    decoration: BoxDecoration(
                      color: gameTheme.gridColor,
                      borderRadius: BorderRadius.circular((_boardSize * 0.04).clamp(8.0, 16.0)), // Responsive radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: (_boardSize * 0.04).clamp(6.0, 12.0),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size,
                        crossAxisSpacing: _tileGap,
                        mainAxisSpacing: _tileGap,
                      ),
                      itemCount: size * size,
                      itemBuilder: (context, index) {
                        final r = index ~/ size;
                        final c = index % size;
                        final value = grid[r][c];
                        final tileId = '$r-$c';
                        final bool isNew = newTileIds.contains(tileId);
                        final bool isMerged = mergedTileIds.contains(tileId);

                        Widget tile = Container(
                          width: _tileContainerSize,
                          height: _tileContainerSize,
                          decoration: BoxDecoration(
                            color: gameTheme.tileColors[value] ??
                                gameTheme.tileColors[0],
                            borderRadius: BorderRadius.circular((_tileContainerSize * 0.1).clamp(4.0, 10.0)), // Responsive radius
                            boxShadow: [
                              if (value > 0)
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: (_tileContainerSize * 0.05).clamp(2.0, 5.0),
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: Center(
                            child: value == 0
                                ? null
                                : FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Padding(
                                      padding: EdgeInsets.all((_tileContainerSize * 0.05).clamp(2.0, 6.0)),
                                      child: Text(
                                        '$value',
                                        style: TextStyle(
                                          fontSize: _getTileNumberFontSize(value),
                                          fontWeight: FontWeight.bold,
                                          color: getTextColorForTile(value),
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        );

                        if (isNew) {
                          return AnimatedBuilder(
                            animation: _newTileAnimation,
                            builder: (context, child) {
                              final scale = _newTileAnimation.value.clamp(0.0, 1.0);
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            child: tile,
                          );
                        }
                        if (isMerged) {
                          return AnimatedBuilder(
                            animation: _scaleAnimation,
                            builder: (context, child) {
                              final scale = _scaleAnimation.value; // Pop effect might go > 1.0
                              return Transform.scale(
                                scale: scale,
                                child: child,
                              );
                            },
                            child: tile,
                          );
                        }
                        return tile;
                      },
                    ),
                  ),
                ),
                SizedBox(height: (_boardSize * 0.05).clamp(10.0, 30.0)), // Responsive spacing
                Container(
                  margin: EdgeInsets.symmetric(horizontal: (_boardSize * 0.05).clamp(10.0, 20.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: (_boardSize * 0.12).clamp(45.0, 60.0), // Responsive height
                          margin: EdgeInsets.only(right: (_boardSize * 0.02).clamp(4.0, 8.0)),
                          child: ElevatedButton(
                            onPressed: _restartGame,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular((_boardSize * 0.025).clamp(8.0, 12.0)),
                              ),
                              elevation: 4,
                              shadowColor: Colors.black.withOpacity(0.2),
                            ),
                            child: Text(
                              'New Game',
                              style: TextStyle(
                                fontSize: _buttonFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: (_boardSize * 0.12).clamp(45.0, 60.0), // Responsive height
                        width: (_boardSize * 0.12).clamp(45.0, 60.0), // Responsive width
                        decoration: BoxDecoration(
                          color: canUndo && !isAnimating
                              ? gameTheme.buttonColor
                              : gameTheme.buttonColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular((_boardSize * 0.025).clamp(8.0, 12.0)),
                          boxShadow: [
                            if (canUndo && !isAnimating)
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: IconButton(
                          iconSize: (_buttonFontSize * 1.5).clamp(20.0, 30.0), // Responsive icon size
                          icon: Icon(
                            Icons.undo_rounded,
                            color: canUndo && !isAnimating
                                ? gameTheme.buttonTextColor
                                : gameTheme.buttonTextColor.withOpacity(0.3),
                          ),
                          onPressed: (canUndo && !isAnimating) ? _undoMove : null,
                          tooltip: 'Undo Move',
                        ),
                      ),
                    ],
                  ),
                ),
                // Game Over and You Win messages could also have responsive font sizes if needed
                if (gameOver && !gameWon)
                  Container( // ... existing game over message ...
                     margin: EdgeInsets.only(top: (_boardSize * 0.06).clamp(15.0, 24.0)),
                     padding:
                         EdgeInsets.symmetric(horizontal: (_boardSize * 0.06).clamp(15.0, 24.0), vertical: (_boardSize * 0.03).clamp(8.0, 12.0)),
                     decoration: BoxDecoration(
                       color: gameTheme.gridColor.withOpacity(0.9),
                       borderRadius: BorderRadius.circular((_boardSize * 0.03).clamp(8.0, 12.0)),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black.withOpacity(0.1),
                           blurRadius: 8,
                           offset: const Offset(0, 2),
                         ),
                       ],
                     ),
                     child: Text(
                       'GAME OVER!',
                       style: TextStyle(
                         fontSize: (_boardSize * 0.07).clamp(20.0, 30.0),
                         fontWeight: FontWeight.bold,
                         color: gameTheme.titleColor,
                         letterSpacing: 2,
                       ),
                     ),
                  ),
                if (gameWon && !gameOver)
                  Container( // ... existing you win message ...
                    margin: EdgeInsets.only(top: (_boardSize * 0.06).clamp(15.0, 24.0)),
                    padding:
                        EdgeInsets.symmetric(horizontal: (_boardSize * 0.06).clamp(15.0, 24.0), vertical: (_boardSize * 0.03).clamp(8.0, 12.0)),
                    decoration: BoxDecoration(
                      color: gameTheme.gridColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular((_boardSize * 0.03).clamp(8.0, 12.0)),
                      gradient: LinearGradient(
                        colors: [
                          gameTheme.tileColors[2048]!.withOpacity(0.9),
                          gameTheme.tileColors[1024]!.withOpacity(0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'YOU WIN! Keep Playing?',
                      style: TextStyle(
                        fontSize: (_boardSize * 0.065).clamp(18.0, 28.0),
                        fontWeight: FontWeight.bold,
                        color: gameTheme.buttonTextColor,
                        letterSpacing: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Updated ScoreDisplay to accept font sizes
class ScoreDisplay extends StatelessWidget {
  final String label;
  final int value;
  final GameTheme theme;
  final Animation<double> pulseAnimation;
  final bool isPulsing;
  final double labelFontSize;
  final double valueFontSize;

  const ScoreDisplay({
    super.key,
    required this.label,
    required this.value,
    required this.theme,
    required this.pulseAnimation,
    required this.isPulsing,
    required this.labelFontSize,
    required this.valueFontSize,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: EdgeInsets.symmetric(horizontal: (labelFontSize * 1.25).clamp(16,24) , vertical: (labelFontSize*0.75).clamp(10,16)), // Responsive padding
      decoration: BoxDecoration(
        color: theme.scoreContainerColor,
        borderRadius: BorderRadius.circular((labelFontSize * 0.5).clamp(6,10)), // Responsive radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: (labelFontSize * 0.5).clamp(4,8),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: labelFontSize,
              letterSpacing: 1.2,
              color: theme.scoreTextColor.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: (labelFontSize * 0.25).clamp(2,5)), // Responsive spacing
          Text(
            '$value',
            style: TextStyle(
              fontSize: valueFontSize,
              fontWeight: FontWeight.bold,
              color: theme.scoreTextColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );

    if (isPulsing) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 1.0, end: 1.05),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale, // Use the direct scale value from tween
            child: child,
          );
        },
        child: content,
      );
    }
    return content;
  }
}
