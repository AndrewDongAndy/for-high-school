class MinesweeperGrid {
  int n, m; // rows and columns
  int mines;
  Point topLeft;
  float squareSize;
  MinesweeperSquare[][] grid;
  int numSafeClicked = 0;
  int numFlagged = 0;
  
  MinesweeperGrid(int n, int m, Point topLeft, float squareSize, int mines) {
    assert n > 0 && m > 0;
    assert 0 <= mines && mines <= n * m;
    this.n = n;
    this.m = m;
    this.mines = mines;
    this.topLeft = topLeft;
    this.squareSize = squareSize;
    grid = new MinesweeperSquare[n][m];
    for (int y = 0; y < n; y++) { // for each row in grid
      for (int x = 0; x < m; x++) { // for each element in row
        Point p = new Point(topLeft.x + x * squareSize, topLeft.y + y * squareSize); // top left of this square
        grid[y][x] = new MinesweeperSquare(p, squareSize);
      }
    }
    generateGrid();
  }
  
  void generateGrid() {
    // places the mines and shows how many mines are around the non-mine squares
    // first, generate mines in random locations
    // do this by shuffling an ArrayList containing all coordinates,
    // then taking the first few coordinates as the mine locations
    ArrayList<int[]> coords = new ArrayList<int[]>();
    for (int y = 0; y < n; y++) { // for each row in grid
      for (int x = 0; x < m; x++) { // for each element in row
        coords.add(new int[]{y, x});
      }
    }
    Collections.shuffle(coords);
    // set mines
    for (int i = 0; i < mines; i++) { // take the first 'mines' coordinates to be mines
      int[] c = coords.get(i);
      grid[c[0]][c[1]].setValue(-1); // -1 means the square is a mine
    }
    for (int y = 0; y < n; y++) { // for each row in grid
      for (int x = 0; x < m; x++) { // for each element in row
        if (!grid[y][x].isMine()) { // if not a mine
          grid[y][x].setValue(minesAround(y, x));
        }
      }
    }
  }
  
  boolean inGrid(int y, int x) {
    return 0 <= y && y < n && 0 <= x && x < m;
  }
  
  int[] getSquare(int x, int y) {
    // returns the row and column containing the given point, or {-1, -1} if none.
    // if mouse is on boundary of a square, returns {-1, -1}.
    // runs in O(1) time (hence fast for larger boards)
    float dx = x - topLeft.x;
    float dy = y - topLeft.y;
    if (dx <= 0 || dx >= m * squareSize // too far to left or right
        || dy <= 0 || dy >= n * squareSize // too far above or below
        || dx % squareSize == 0 || dy % squareSize == 0) { // on boundary of a square
      return new int[]{-1, -1};
    }
    return new int[]{(int) (dy / squareSize), (int) (dx / squareSize)};
  }
  
  int minesAround(int y, int x) {
    int ret = 0;
    for (int i = max(0, y - 1); i <= min(n - 1, y + 1); i++) { // for each row within 1 of row y
      for (int j = max(0, x - 1); j <= min(m - 1, x + 1); j++) { // for each element within 1 of column x
        if (i == y && j == x) { // if this is the square we are checking
          continue; // skip this square
        }
        if (grid[i][j].isMine()) { // if square (i, j) is a mine
          ret++;
        }
      }
    }
    return ret;
  }
  
  int flaggedAround(int y, int x) {
    int ret = 0;
    for (int i = max(0, y - 1); i <= min(n - 1, y + 1); i++) { // for each row within 1 of row y
      for (int j = max(0, x - 1); j <= min(m - 1, x + 1); j++) { // for each element within 1 of column x
        if (i == y && j == x) { // if this is the square we are checking
          continue; // skip this square
        }
        if (grid[i][j].isFlagged()) { // if square (i, j) is flagged
          ret++;
        }
      }
    }
    return ret;
  }
  
  void bfs(int y, int x) {
    // queue implemented as an array
    int beg = 0, end = -1; // beginning and end of queue
    int[][] q = new int[n * m][2]; // queue
    q[++end] = new int[]{y, x};
    grid[y][x].clicked = true;
    int[][] dirs = {{1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}};
    while (beg <= end) { // while the queue contains at least one element
      int[] p = q[beg++];
      for (int[] d : dirs) { // for each direction we can go
        int ny = p[0] + d[0];
        int nx = p[1] + d[1];
        if (!inGrid(ny, nx) || grid[ny][nx].isClicked()) { // if this square is out of the grid or already clicked
          continue; // don't search
        }
        numSafeClicked++;
        if (grid[ny][nx].isFlagged()) { // if square (ny, nx) is flagged
          grid[ny][nx].setFlagged(false);
          numFlagged--;
        }
        grid[ny][nx].setClicked(true);
        clickSquare(ny, nx);
        if (grid[ny][nx].getValue() == 0) { // if square (ny, nx) has no mines surrounding it
          q[++end] = new int[]{ny, nx};
        }
      }
    }
  }
  
  void clickSquare(int y, int x) {
    // left mouse click
    assert inGrid(y, x);
    if (grid[y][x].isClicked() || grid[y][x].isFlagged()) { // if this square is clicked or flagged
      return; // don't process this click
    }
    grid[y][x].setClicked(true);
    if (!grid[y][x].isMine()) { // if this square is safe (not a mine)
      numSafeClicked++;
      if (grid[y][x].getValue() == 0) { // if square (y, x) has no mines surrounding it
        bfs(y, x); // perform floodfill
      }
    } else { // this square is a mine; game over
      lost = true;
    }
    won = (mines + numSafeClicked == n * m);
  }
  
  void toggleFlagged(int y, int x) {
    if (grid[y][x].isClicked()) { // if square (y, x) is clicked
      return;
    }
    if (!grid[y][x].isFlagged()) { // if square (y, x) was not flagged
      numFlagged++;
    } else { // the square (y, x) was flagged
      numFlagged--;
    }
    grid[y][x].toggleFlagged();
  }
  
  void sweep(int y, int x) {
    assert grid[y][x].isClicked();
    assert !grid[y][x].isMine();
    if (flaggedAround(y, x) != grid[y][x].getValue()) { // number of flagged squares around is not equal to this square's value
      return; // the square is not sweepable
    }
    for (int i = max(0, y - 1); i <= min(n - 1, y + 1); i++) { // for each row within 1 of row y
      for (int j = max(0, x - 1); j <= min(m - 1, x + 1); j++) { // for each element within 1 of column x
        if (i == y && j == x) { // if this is the square we are checking
          continue; // skip this square
        }
        if (!grid[i][j].isFlagged()) { // square (i, j) is not flagged
          clickSquare(i, j);
        }
      }
    }
  }
  
  void display(boolean detectMouse) {
    for (int i = 0; i < n; i++) { // for each row in grid
      for (int j = 0; j < m; j++) { // for each element in row
        if (grid[i][j].isClicked()) { // square (i, j) is clicked
          fill(#958E8E);
        } else if (detectMouse && grid[i][j].contains(mouseX, mouseY)) { // square i, j is not clicked
          fill(#6CAA6F); // mouse is hovering over this square
        } else { // no response to input needed; colour in checkerboard pattern
          // if row and column have same parity, use a lighter shade of green;
          // otherwise, use a darker shade
          fill(i % 2 == j % 2 ? #44C149 : #228B26);
        }
        grid[i][j].display();
      }
    }
  }
}
