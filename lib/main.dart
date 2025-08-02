import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

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
    final themeModeIndex = prefs.getInt('theme_mode') ?? 0;
    setState(() {
      _themeMode = ThemeMode.values[themeModeIndex];
    });
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', themeMode.index);
  }

  void _toggleTheme() {
    setState(() {
      switch (_themeMode) {
        case ThemeMode.system:
          _themeMode = ThemeMode.light;
          break;
        case ThemeMode.light:
          _themeMode = ThemeMode.dark;
          break;
        case ThemeMode.dark:
          _themeMode = ThemeMode.system;
          break;
      }
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
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.brown,
    scaffoldBackgroundColor: const Color(0xFF1A1A1A),
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
      2048: Color(0xFFFFD700),
      4096: Color(0xFF9B59B6),
      8192: Color(0xFF8E44AD),
    },
    textColors: {
      2: Color(0xFFE5E5E5),
      4: Color(0xFFE5E5E5),
    },
  );
}

class Game2048 extends StatefulWidget {
  const Game2048({super.key, required this.onThemeToggle, required this.currentThemeMode});

  final VoidCallback onThemeToggle;
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
  List<List<int>> previousGrid = List.generate(size, (_) => List.filled(size, 0));
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
  
  List<TileData> animatingTiles = [];
  Set<String> newTileIds = {};
  Set<String> mergedTileIds = {};

  @override
  void initState() {
    super.initState();
    
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 80), // Reduced from 120ms
      vsync: this,
    );
    
    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 120), // Reduced from 200ms
      vsync: this,
    );
    
    _newTileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 80), // Reduced from 100ms
      vsync: this,
    );
    
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400), // Reduced from 600ms
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideAnimationController, curve: Curves.easeOutCubic),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _scaleAnimationController, curve: Curves.elasticOut),
    );
    
    _newTileAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _newTileAnimationController, curve: Curves.easeOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseAnimationController, curve: Curves.easeInOut),
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

  void _addRandomTile({bool animate = true}) {
    List<Point<int>> empty = [];
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (grid[r][c] == 0) empty.add(Point(r, c));
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
          // Reduced cleanup delay from 50ms to 30ms
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
      for (int c = 0; c < size; c++) {
        previousGrid[r][c] = grid[r][c];
      }
    }
  }

  void _undoMove() {
    if (!canUndo || isAnimating) return;
    
    setState(() {
      score = previousScore;
      for (int r = 0; r < size; r++) {
        for (int c = 0; c < size; c++) {
          grid[r][c] = previousGrid[r][c];
        }
      }
      canUndo = false;
      newTileIds.clear();
      mergedTileIds.clear();
    });
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
      }
      _saveHighScore();
      // Reset new high score flag after animation
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
    mergedTileIds.clear();
    
    for (int r = 0; r < size; r++) {
      List<int> row = [];
      
      // Collect non-zero values
      for (int c = 0; c < size; c++) {
        if (grid[r][c] != 0) {
          row.add(grid[r][c]);
        }
      }
      
      // Merge adjacent equal values
      for (int i = 0; i < row.length - 1; i++) {
        if (row[i] == row[i + 1]) {
          row[i] *= 2;
          score += row[i];
          row[i + 1] = 0;
          
          // Mark merged tile position
          mergedTileIds.add('$r-$i');
          
          if (row[i] == 2048 && !gameWon) {
            gameWon = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              _showWinDialog();
            });
          }
        }
      }
      
      // Remove zeros and create final row
      List<int> finalRow = row.where((val) => val != 0).toList();
      while (finalRow.length < size) finalRow.add(0);
      
      // Check if anything moved
      for (int c = 0; c < size; c++) {
        if (grid[r][c] != finalRow[c]) moved = true;
        grid[r][c] = finalRow[c];
      }
    }
    
    return moved;
  }

  bool _moveRight() {
    _saveGameState();
    bool moved = false;
    mergedTileIds.clear();
    
    for (int r = 0; r < size; r++) {
      List<int> row = [];
      
      // Collect non-zero values from right to left
      for (int c = size - 1; c >= 0; c--) {
        if (grid[r][c] != 0) {
          row.add(grid[r][c]);
        }
      }
      
      // Merge adjacent equal values
      for (int i = 0; i < row.length - 1; i++) {
        if (row[i] == row[i + 1]) {
          row[i] *= 2;
          score += row[i];
          row[i + 1] = 0;
          
          mergedTileIds.add('$r-${size - 1 - i}');
          
          if (row[i] == 2048 && !gameWon) {
            gameWon = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              _showWinDialog();
            });
          }
        }
      }
      
      // Remove zeros and create final row
      List<int> finalRow = row.where((val) => val != 0).toList();
      while (finalRow.length < size) finalRow.add(0);
      
      // Place values from right to left
      for (int i = 0; i < size; i++) {
        int newValue = i < finalRow.length ? finalRow[i] : 0;
        int col = size - 1 - i;
        if (grid[r][col] != newValue) moved = true;
        grid[r][col] = newValue;
      }
    }
    
    return moved;
  }

  bool _moveUp() {
    _saveGameState();
    bool moved = false;
    mergedTileIds.clear();
    
    for (int c = 0; c < size; c++) {
      List<int> col = [];
      
      // Collect non-zero values
      for (int r = 0; r < size; r++) {
        if (grid[r][c] != 0) {
          col.add(grid[r][c]);
        }
      }
      
      // Merge adjacent equal values
      for (int i = 0; i < col.length - 1; i++) {
        if (col[i] == col[i + 1]) {
          col[i] *= 2;
          score += col[i];
          col[i + 1] = 0;
          
          mergedTileIds.add('$i-$c');
          
          if (col[i] == 2048 && !gameWon) {
            gameWon = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              _showWinDialog();
            });
          }
        }
      }
      
      // Remove zeros and create final column
      List<int> finalCol = col.where((val) => val != 0).toList();
      while (finalCol.length < size) finalCol.add(0);
      
      // Check if anything moved
      for (int r = 0; r < size; r++) {
        if (grid[r][c] != finalCol[r]) moved = true;
        grid[r][c] = finalCol[r];
      }
    }
    
    return moved;
  }

  bool _moveDown() {
    _saveGameState();
    bool moved = false;
    mergedTileIds.clear();
    
    for (int c = 0; c < size; c++) {
      List<int> col = [];
      
      // Collect non-zero values from bottom to top
      for (int r = size - 1; r >= 0; r--) {
        if (grid[r][c] != 0) {
          col.add(grid[r][c]);
        }
      }
      
      // Merge adjacent equal values
      for (int i = 0; i < col.length - 1; i++) {
        if (col[i] == col[i + 1]) {
          col[i] *= 2;
          score += col[i];
          col[i + 1] = 0;
          
          mergedTileIds.add('${size - 1 - i}-$c');
          
          if (col[i] == 2048 && !gameWon) {
            gameWon = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              _showWinDialog();
            });
          }
        }
      }
      
      // Remove zeros and create final column
      List<int> finalCol = col.where((val) => val != 0).toList();
      while (finalCol.length < size) finalCol.add(0);
      
      // Place values from bottom to top
      for (int i = 0; i < size; i++) {
        int newValue = i < finalCol.length ? finalCol[i] : 0;
        int row = size - 1 - i;
        if (grid[row][c] != newValue) moved = true;
        grid[row][c] = newValue;
      }
    }
    
    return moved;
  }

  bool _isGameOver() {
    // Check for empty cells
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (grid[r][c] == 0) return false;
      }
    }
    
    // Check for possible merges
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
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
    
    // Add minimum velocity threshold to prevent accidental moves
    const double minVelocity = 100.0;
    
    // Check if velocity is significant enough
    if (velocity.dx.abs() < minVelocity && velocity.dy.abs() < minVelocity) {
      return; // Ignore very slow movements
    }
    
    // Improved direction detection with larger threshold
    if (velocity.dx.abs() > velocity.dy.abs() * 1.5) {
      // Horizontal swipe - require dx to be significantly larger than dy
      if (velocity.dx > minVelocity) {
        moved = _moveRight();
      } else if (velocity.dx < -minVelocity) {
        moved = _moveLeft();
      }
    } else if (velocity.dy.abs() > velocity.dx.abs() * 1.5) {
      // Vertical swipe - require dy to be significantly larger than dx
      if (velocity.dy > minVelocity) {
        moved = _moveDown();
      } else if (velocity.dy < -minVelocity) {
        moved = _moveUp();
      }
    }
    
    if (moved) {
      setState(() {
        isAnimating = true;
        canUndo = true;
      });
      
      // Simplified animation - run slide and scale simultaneously for faster response
      _slideAnimationController.forward();
      if (mergedTileIds.isNotEmpty) {
        _scaleAnimationController.forward().then((_) {
          _scaleAnimationController.reverse();
        });
      }
      
      // Finish move after slide animation completes
      Future.delayed(const Duration(milliseconds: 80), () {
        _slideAnimationController.reset();
        _finishMove();
      });
    }
  }

  void _finishMove() {
    if (!mounted) return;
    setState(() {
      mergedTileIds.clear();
      isAnimating = false;
    });
    
    // Reduce delay significantly for immediate tile generation
    Future.delayed(const Duration(milliseconds: 20), () {
      if (mounted) {
        _addRandomTile(animate: true);
        _updateHighScore();
        if (_isGameOver()) {
          if (mounted) {
            setState(() {
              gameOver = true;
            });
            _showGameOverDialog();
          }
        }
      }
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 You Win!', style: TextStyle(fontSize: 24)),
        content: const Text('You reached 2048! Continue playing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: const Text('New Game'),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF8EF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Game Over Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B6B).withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '💀',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Game Over Title
              const Text(
                'GAME OVER',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF776E65),
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Score Container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFBBADA0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text(
                      'FINAL SCORE',
                      style: TextStyle(
                        color: Color(0xFFF9F6F2),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$score',
                      style: const TextStyle(
                        color: Color(0xFFF9F6F2),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              
              if (score == highScore && score > 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.star,
                        color: Color(0xFF776E65),
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'NEW HIGH SCORE!',
                        style: TextStyle(
                          color: Color(0xFF776E65),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _resetGame();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8F7A66),
                    foregroundColor: const Color(0xFFF9F6F2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'TRY AGAIN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetGame() {
    if (isAnimating) return; // Block reset during animation
    _slideAnimationController.reset();
    _scaleAnimationController.reset();
    _newTileAnimationController.reset();
    if (mounted) {
      setState(() {
        grid = List.generate(size, (_) => List.filled(size, 0));
        previousGrid = List.generate(size, (_) => List.filled(size, 0));
        score = 0;
        previousScore = 0;
        gameWon = false;
        gameOver = false;
        isAnimating = false;
        canUndo = false;
        animatingTiles.clear();
        newTileIds.clear();
        mergedTileIds.clear();
      });
    }
    // Add initial tiles immediately without any delay
    _addRandomTile(animate: false);
    _addRandomTile(animate: false);
  }

  GameTheme get _currentTheme {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? GameTheme.dark : GameTheme.light;
  }

  String get _themeIcon {
    switch (widget.currentThemeMode) {
      case ThemeMode.system:
        return '🌓';
      case ThemeMode.light:
        return '☀️';
      case ThemeMode.dark:
        return '🌙';
    }
  }

  String get _themeTooltip {
    switch (widget.currentThemeMode) {
      case ThemeMode.system:
        return 'System Theme';
      case ThemeMode.light:
        return 'Light Theme';
      case ThemeMode.dark:
        return 'Dark Theme';
    }
  }

  Color _getTileColor(int value) {
    final theme = _currentTheme;
    if (value == 0) return theme.tileColors[0]!.withOpacity(0.5);
    return theme.tileColors[value] ?? theme.tileColors[8192]!;
  }

  Color _getTextColor(int value) {
    final theme = _currentTheme;
    return theme.textColors[value] ?? 
           (value <= 4 ? theme.titleColor : const Color(0xFFF9F6F2));
  }

  double _getTileSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final availableWidth = screenWidth - 60; // Account for padding
    final availableHeight = screenHeight * 0.5; // Use half screen height for game board
    
    // Calculate tile size based on available space
    final maxTileSize = min(
      (availableWidth - 40) / size, // 40 for margins between tiles
      (availableHeight - 40) / size,
    );
    
    return max(60.0, min(maxTileSize, 90.0)); // Min 60, max 90
  }

  double _getFontSize(int value, double tileSize) {
    if (value >= 10000) return tileSize * 0.22;
    if (value >= 1000) return tileSize * 0.26;
    if (value >= 100) return tileSize * 0.30;
    return tileSize * 0.34;
  }

  Widget _buildTile(int value, int row, int col, double tileSize) {
    bool isNew = newTileIds.contains('$row-$col');
    bool isMerged = mergedTileIds.contains('$row-$col');
    
    double scale = 1.0;
    double opacity = 1.0;
    
    if (isNew) {
      scale = _newTileAnimation.value.clamp(0.0, 1.0);
      opacity = _newTileAnimation.value.clamp(0.0, 1.0);
    } else if (isMerged) {
      scale = _scaleAnimation.value.clamp(0.8, 1.5);
    }
    
    // Cache expensive calculations
    final borderRadius = tileSize * 0.08;
    final margin = tileSize * 0.05;
    
    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Container(
          margin: EdgeInsets.all(margin),
          width: tileSize,
          height: tileSize,
          decoration: BoxDecoration(
            color: _getTileColor(value),
            borderRadius: BorderRadius.circular(borderRadius),
            // Simplified shadows for better performance
            boxShadow: value != 0 ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ] : null,
          ),
          child: Center(
            child: Text(
              value == 0 ? '' : '$value',
              style: TextStyle(
                fontSize: _getFontSize(value, tileSize),
                fontWeight: FontWeight.w900,
                color: _getTextColor(value),
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tileSize = _getTileSize(context);
    final gridSize = (tileSize + (tileSize * 0.1)) * size + 16;
    final theme = _currentTheme;
    
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '2048',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: theme.titleColor,
                      letterSpacing: -1,
                    ),
                  ),
                  Row(
                    children: [
                      // Theme Toggle Button
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Tooltip(
                          message: _themeTooltip,
                          child: InkWell(
                            onTap: widget.onThemeToggle,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.buttonColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: theme.buttonColor.withOpacity(0.3)),
                              ),
                              child: Text(
                                _themeIcon,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Score Container
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final scoreAreaWidth = maxWidth * 0.7;
                final buttonWidth = (maxWidth * 0.25 - 18).clamp(90.0, 140.0);
                final boardSize = maxWidth * 0.92;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: scoreAreaWidth,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.scoreContainerColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text('SCORE', style: TextStyle(color: theme.scoreTextColor, fontSize: 12, fontWeight: FontWeight.bold)),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: Text('$score', key: ValueKey(score), style: TextStyle(color: theme.scoreTextColor, fontSize: 18, fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text('HIGH SCORE', style: TextStyle(color: theme.scoreTextColor, fontSize: 12, fontWeight: FontWeight.bold)),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 400),
                                child: Text('$highScore', key: ValueKey(highScore), style: TextStyle(color: isNewHighScore ? const Color(0xFFFFD700) : theme.scoreTextColor, fontSize: 18, fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: maxWidth * 0.95, // Increased from 0.9 to make buttons wider
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 120, // Fixed wider width for better appearance
                              height: 48, // Increased height from 44 to 48
                              child: ElevatedButton.icon(
                                onPressed: canUndo && !isAnimating ? _undoMove : null,
                                icon: const Icon(Icons.undo, size: 18), // Increased icon size
                                label: const Text('Undo', style: TextStyle(fontSize: 14)), // Increased font size
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: canUndo ? theme.buttonColor : Colors.grey[400],
                                  foregroundColor: theme.buttonTextColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Increased border radius
                                  elevation: canUndo ? 3 : 0, // Increased elevation
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Increased padding
                                ),
                              ),
                            ),
                            const SizedBox(width: 12), // Increased spacing
                            SizedBox(
                              width: 120, // Fixed wider width for better appearance
                              height: 48, // Increased height from 44 to 48
                              child: ElevatedButton(
                                onPressed: _resetGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.buttonColor,
                                  foregroundColor: theme.buttonTextColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Increased border radius
                                  elevation: 3, // Increased elevation
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), // Increased padding
                                ),
                                child: const Text('New Game', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)), // Increased font size
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onPanEnd: _handleSwipe, // Use onPanEnd instead of separate horizontal/vertical
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Calculate tile size based on available width
                            final availableWidth = min(boardSize, constraints.maxWidth - 16);
                            final cellSize = (availableWidth - 16) / size;
                            final cellMargin = cellSize * 0.05;
                            final effectiveCellSize = cellSize - (cellMargin * 2);
                            
                            return Container(
                              width: availableWidth,
                              height: availableWidth,
                              decoration: BoxDecoration(
                                color: theme.gridColor,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.12),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(size, (r) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(size, (c) {
                                      int val = grid[r][c];
                                      bool isNew = newTileIds.contains('$r-$c');
                                      bool isMerged = mergedTileIds.contains('$r-$c');
                                      
                                      double scale = 1.0;
                                      double opacity = 1.0;
                                      
                                      if (isNew) {
                                        scale = _newTileAnimation.value.clamp(0.0, 1.0);
                                        opacity = _newTileAnimation.value.clamp(0.0, 1.0);
                                      } else if (isMerged) {
                                        scale = _scaleAnimation.value.clamp(0.8, 1.5);
                                      }
                                      
                                      return Transform.scale(
                                        scale: scale,
                                        child: Opacity(
                                          opacity: opacity,
                                          child: Container(
                                            margin: EdgeInsets.all(cellMargin),
                                            width: effectiveCellSize,
                                            height: effectiveCellSize,
                                            decoration: BoxDecoration(
                                              color: _getTileColor(val),
                                              borderRadius: BorderRadius.circular(effectiveCellSize * 0.08),
                                              boxShadow: val != 0 ? [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.1),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ] : null,
                                            ),
                                            child: Center(
                                              child: Text(
                                                val == 0 ? '' : '$val',
                                                style: TextStyle(
                                                  fontSize: _getFontSize(val, effectiveCellSize),
                                                  fontWeight: FontWeight.w900,
                                                  color: _getTextColor(val),
                                                  letterSpacing: -0.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            
            // Instructions
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.instructionBgColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Theme.of(context).brightness == Brightness.dark 
                    ? Border.all(color: theme.gridColor.withOpacity(0.3)) 
                    : null,
              ),
              child: Text(
                'HOW TO PLAY: Swipe to move tiles. When two tiles with the same number touch, they merge into one!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.instructionTextColor,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
