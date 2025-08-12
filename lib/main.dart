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
    // Defaults to 0 (system) if not found, which is desired for first launch.
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
    // Added context
    ThemeMode newThemeMode;
    // Access platform brightness using context from the widget tree
    // This requires context to be available where _toggleTheme is defined or called from.
    // For _Game2048AppState, context is implicitly available in its methods if needed for MediaQuery.
    // However, if called via a callback from a child, that child needs to pass its context.
    // Here, Game2048 will pass its context.
    final Brightness platformBrightness =
        MediaQuery.of(context).platformBrightness;

    switch (_themeMode) {
      case ThemeMode.system:
        // If system, pick the opposite of current system theme then cycle between light/dark
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
    _saveThemeMode(_themeMode); // Save the explicit light/dark choice
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tile Fusion 2048',
      themeMode: _themeMode,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      home: Game2048(
        onThemeToggle: _toggleTheme, // Pass the method reference
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
      // Higher values typically use a lighter text color
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
      8: Color(0xFF8B6914), // Darker orange/brown
      16: Color(0xFFA67C14), // Darker orange
      32: Color(0xFFB58900), // Darker yellow
      64: Color(0xFFCB4B16), // Darker red-orange
      128: Color(0xFFDC8C2C), // Darker orange-yellow
      256: Color(0xFFE5A532), // Darker yellow-orange
      512: Color(0xFFEDB32C), // Darker yellow
      1024: Color(0xFFF5C542), // Lighter yellow for dark theme
      2048: Color(0xFFEAA220), // Changed from Color(0xFFFFD700) to a more muted gold/amber
      4096: Color(0xFF9B59B6), // Purple
      8192: Color(0xFF8E44AD), // Darker Purple
    },
    textColors: {
      2: Color(0xFFE5E5E5),
      4: Color(0xFFE5E5E5),
      // Higher values typically use a lighter text color
      8: Color(0xFFE5E5E5),
      16: Color(0xFFE5E5E5),
      32: Color(0xFFE5E5E5),
      64: Color(0xFFE5E5E5),
      128: Color(0xFFE5E5E5),
      256: Color(0xFFE5E5E5),
      512: Color(0xFFE5E5E5),
      1024: Color(0xFF1A1A1A), // Dark text on light yellow
      2048: Color(0xFF1A1A1A), // Dark text on gold
      4096: Color(0xFFE5E5E5),
      8192: Color(0xFFE5E5E5),
    },
  );
}

class Game2048 extends StatefulWidget {
  const Game2048({
    super.key,
    required this.onThemeToggle,
    required this.currentThemeMode,
  });

  final void Function(BuildContext) onThemeToggle; // Updated signature
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

  // These animations can be used by AnimatedBuilder widgets for tile animations
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _newTileAnimation;
  late Animation<double> _pulseAnimation;

  Set<String> newTileIds = {};
  Set<String> mergedTileIds = {};

  @override
  void initState() {
    super.initState();

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 80), // Fast for slide
      vsync: this,
    );

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 120), // Slightly longer for pop
      vsync: this,
    );

    _newTileAnimationController = AnimationController(
      duration:
          const Duration(milliseconds: 80), // Fast for new tile appearance
      vsync: this,
    );

    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
      // lowerBound: 1.0, // Removed, defaults to 0.0
      // upperBound: 1.05, // Removed, defaults to 1.0
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _slideAnimationController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      // Pop effect
      CurvedAnimation(
          parent: _scaleAnimationController, curve: Curves.easeOutBack),
    );

    _newTileAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      // Fade/Scale in
      CurvedAnimation(
          parent: _newTileAnimationController, curve: Curves.easeOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseAnimationController, // This controller is now 0.0-1.0
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
      // Allow undo even if gameOver is true
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
        // Ensure the value is reset to the very beginning of the animation range (0.0).
        _pulseAnimationController.value = _pulseAnimationController.lowerBound;

        _pulseAnimationController.forward().then((_) {
          // This Future completes when the animation is stopped or reaches the end.
          if (mounted) {
            // Ensure widget is still mounted
            // Check if the animation completed by reaching the upper bound (1.0).
            if (_pulseAnimationController.status == AnimationStatus.completed) {
              // Explicitly stop and set to upperBound before reversing,
              // to ensure reverse starts exactly from upperBound.
              _pulseAnimationController.stop();
              _pulseAnimationController.value =
                  _pulseAnimationController.upperBound;
              _pulseAnimationController.reverse();
            }
            // If the animation didn't complete (e.g., was stopped prematurely),
            // we don't automatically reverse. It should already be stopped.
          }
        }).catchError((error) {
          // Log the error for diagnostics.
          // TODO: Replace with proper logging in production
          // print('Error during pulse animation: $error');
          if (mounted) {
            // Reset controller to a known safe state on error.
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
    if (isAnimating || (gameOver && !gameWon)) {
      // Allow moves if gameWon but still playing.
      // Prevent moves if game is truly over (gameOver is true AND gameWon is false)
      // This condition was originally: if (isAnimating || gameOver) { ... }
      // Which prevented moves after gameWon if the board was full.
      // The new condition "if (isAnimating || (gameOver && !gameWon))" might also be too restrictive.
      // The simplest is "if (isAnimating || gameOver)" but this is the problem point.
      // Let's adjust this. Game over should strictly mean no moves possible.
      // Winning (2048) doesn't mean game over. You can continue playing.
      // So, if gameOver is true, no moves allowed. That's it.
      return;
    }
    if (gameOver) return; // If game over state is already true, no more moves.

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
          canUndo = true; // Enable undo after a successful move
        });
      }

      _slideAnimationController.forward();
      if (mergedTileIds.isNotEmpty) {
        _scaleAnimationController.forward().then((_) {
          _scaleAnimationController
              .reverse(); // Or .reset() depending on desired effect after pop
        });
      }

      // Wait for slide animation to conceptually finish before adding new tile
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

    _addRandomTile(); // Add new tile after move and animations start

    if (mounted) {
      setState(() {
        isAnimating = false;
        // Note: mergedTileIds is cleared at the start of a move.
        // newTileIds are managed within _addRandomTile and its animation callbacks.
      });
    }

    _updateHighScore(); // This might set gameWon if 2048 is reached and _showWinDialog is called.

    // Check for game over state regardless of whether the game has been "won"
    // (i.e., 2048 tile achieved). The player can continue playing after winning.
    if (_isGameOver()) {
      if (mounted) {
        setState(() {
          gameOver = true;
        });
        // Delay showing dialog to allow other animations (like win dialog) to settle.
        // Also, it's possible a quick undo happens, so re-check gameOver status.
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && gameOver) {
            // Removed !gameWon condition
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
                // gameWon remains true. If _isGameOver() is true, _finishMove will handle it.
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
        // Changed context name to avoid conflict
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
            if (canUndo) // Conditionally add the Undo button
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
        // Changed context name
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
                Navigator.of(dialogContext).pop(); // Use dialogContext
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameTheme = widget.currentThemeMode == ThemeMode.dark
        ? GameTheme.dark
        : GameTheme.light;
    final screenWidth = MediaQuery.of(context).size.width;
    final double gridSize = screenWidth * 0.9; // 90% of screen width
    final double tileSize =
        (gridSize - (size + 1) * 8) / size; // 8 is padding between tiles

    // Determine text color based on tile value
    Color getTextColorForTile(int value) {
      if (value >= 8) {
        return gameTheme.textColors[8] ??
            (widget.currentThemeMode == ThemeMode.dark
                ? Colors.white
                : Colors.black); // Default for higher if not specified
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
                color: gameTheme.titleColor, fontWeight: FontWeight.bold)),
        backgroundColor: gameTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              widget.currentThemeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : widget.currentThemeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons
                          .brightness_auto, // Shows auto if current is system
              color: gameTheme.titleColor,
            ),
            onPressed: () => widget.onThemeToggle(context), // Pass context here
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: gameTheme.titleColor),
            onPressed: _showInstructionsDialog,
          ),
          IconButton(
            // Added Support Me button
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ScoreDisplay(
                    label: 'SCORE',
                    value: score,
                    theme: gameTheme,
                    pulseAnimation: _pulseAnimation,
                    isPulsing: false), // isPulsing can be false for score
                ScoreDisplay(
                    label: 'HIGH SCORE',
                    value: highScore,
                    theme: gameTheme,
                    pulseAnimation: _pulseAnimation,
                    isPulsing: isNewHighScore),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onHorizontalDragEnd: (details) {
                // Added a check for 'gameOver' state before handling swipe.
                if (gameOver) return;
                if (details.primaryVelocity! > 200)
                  _handleSwipe(DragEndDetails(
                      velocity: Velocity(
                          pixelsPerSecond:
                              Offset(details.primaryVelocity!, 0))));
                else if (details.primaryVelocity! < -200)
                  _handleSwipe(DragEndDetails(
                      velocity: Velocity(
                          pixelsPerSecond:
                              Offset(details.primaryVelocity!, 0))));
              },
              onVerticalDragEnd: (details) {
                // Added a check for 'gameOver' state before handling swipe.
                if (gameOver) return;
                if (details.primaryVelocity! > 200)
                  _handleSwipe(DragEndDetails(
                      velocity: Velocity(
                          pixelsPerSecond:
                              Offset(0, details.primaryVelocity!))));
                else if (details.primaryVelocity! < -200)
                  _handleSwipe(DragEndDetails(
                      velocity: Velocity(
                          pixelsPerSecond:
                              Offset(0, details.primaryVelocity!))));
              },
              child: Container(
                width: gridSize,
                height: gridSize,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: gameTheme.gridColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
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
                      width: tileSize,
                      height: tileSize,
                      decoration: BoxDecoration(
                        color: gameTheme.tileColors[value] ??
                            gameTheme.tileColors[0],
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          if (value > 0)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
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
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    '$value',
                                    style: TextStyle(
                                      fontSize: value > 1000 ? 22 : 28,
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
                      // Clamp the animation value to [0, 1] to avoid assertion errors
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
                          final scale = _scaleAnimation.value.clamp(0.0, 1.05);
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: tile,
                      );
                    }
                    // TODO: Implement slide animations using _slideAnimation and transforming tile positions.
                    // This is more complex and usually involves an overlay or stack of tiles.

                    return tile; // Default tile without specific animation wrapper for this example
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.only(right: 8),
                      child: ElevatedButton(
                        onPressed: _restartGame,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          shadowColor: Colors.black.withOpacity(0.2),
                        ),
                        child: const Text(
                          'New Game',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: canUndo && !isAnimating
                          ? gameTheme.buttonColor
                          : gameTheme.buttonColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
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
            if (gameOver && !gameWon)
              Container(
                margin: const EdgeInsets.only(top: 24.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: gameTheme.gridColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
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
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: gameTheme.titleColor,
                    letterSpacing: 2,
                  ),
                ),
              ),
            if (gameWon && !gameOver)
              Container(
                margin: const EdgeInsets.only(top: 24.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: gameTheme.gridColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: gameTheme.buttonTextColor,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Helper widget for Score Display with optional pulsing
class ScoreDisplay extends StatelessWidget {
  final String label;
  final int value;
  final GameTheme theme;
  final Animation<double> pulseAnimation;
  final bool isPulsing;

  const ScoreDisplay({
    super.key,
    required this.label,
    required this.value,
    required this.theme,
    required this.pulseAnimation,
    required this.isPulsing,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scoreContainerColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
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
              fontSize: 16,
              letterSpacing: 1.2,
              color: theme.scoreTextColor.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 24,
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
            scale: scale.clamp(1.0, 1.05),
            child: child,
          );
        },
        child: content,
        onEnd: () {},
      );
    }
    return content;
  }
}
