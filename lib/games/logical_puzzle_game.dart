// logical_puzzle_game.dart
import 'package:flutter/material.dart';

//Level 3 class
class TriangularLatticePainter extends CustomPainter {
  final int divisions; // 2 -> 4 small triangles, 3 -> 9 small triangles
  TriangularLatticePainter({required this.divisions});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Equilateral triangle vertices: A (top), B (bottom-left), C (bottom-right)
    final A = Offset(size.width / 2, 0);
    final B = Offset(0, size.height);
    final C = Offset(size.width, size.height);

    // Draw outer triangle
    final outline = Path()
      ..moveTo(A.dx, A.dy)
      ..lineTo(B.dx, B.dy)
      ..lineTo(C.dx, C.dy)
      ..close();
    canvas.drawPath(outline, stroke);

    // Helper to lerp points
    Offset lerp(Offset p, Offset q, double t) => Offset(
      p.dx + (q.dx - p.dx) * t,
      p.dy + (q.dy - p.dy) * t,
    );

    // Draw lattice: lines parallel to all three sides
    for (int k = 1; k < divisions; k++) {
      final t = k / divisions;

      // Lines parallel to AB: endpoints on AC and BC
      final p1 = lerp(A, C, t);
      final p2 = lerp(B, C, t);
      canvas.drawLine(p1, p2, stroke);

      // Lines parallel to AC: endpoints on AB and CB
      final q1 = lerp(A, B, t);
      final q2 = lerp(C, B, t);
      canvas.drawLine(q1, q2, stroke);

      // Lines parallel to BC: endpoints on AB and AC
      final r1 = lerp(B, A, t);
      final r2 = lerp(C, A, t);
      canvas.drawLine(r1, r2, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

//Level 6 class
class GridBoxPainter extends CustomPainter {
  final int rows;
  final int columns;

  GridBoxPainter({required this.rows, required this.columns});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final cellWidth = size.width / columns;
    final cellHeight = size.height / rows;

    for (int r = 0; r <= rows; r++) {
      final y = r * cellHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (int c = 0; c <= columns; c++) {
      final x = c * cellWidth;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
// Level 9 class
class InvertedTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final bottomLeft = Offset(0, 0);
    final bottomRight = Offset(size.width, 0);
    final top = Offset(size.width / 2, size.height);

    final path = Path()
      ..moveTo(bottomLeft.dx, bottomLeft.dy)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..lineTo(top.dx, top.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class UpsideDownTriangle extends StatelessWidget {
  final int topLeft;
  final int topRight;
  final int? bottom;

  const UpsideDownTriangle({
    super.key,
    required this.topLeft,
    required this.topRight,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    const double w = 50;   // compact width
    const double h = 50;   // compact height
    const double pad = 0;  // text padding from edges

    return SizedBox(
      width: w + 20,
      height: h + 20,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: const Size(w, h),
            painter: InvertedTrianglePainter(),
          ),
          // Two numbers at the base corners (top edge in screen coords)
          Positioned(
            top: pad -2,
            left: pad -10,
            child: Text("$topLeft", style: const TextStyle(fontSize: 14)),
          ),
          Positioned(
            top: pad - 2,
            right: pad,
            child: Text("$topRight", style: const TextStyle(fontSize: 14)),
          ),
          // Single number at the bottom tip (centered)
          Positioned(
            bottom: pad - 2,
            left: -17,
            right: 0,
            child: Text(
              bottom != null ? "$bottom" : "?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// Level 15
class _GridCell extends StatelessWidget {
  final String text;
  const _GridCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontFamily: 'Roboto Mono', // monospaced for crisp alignment
          ),
        ),
      ),
    );
  }
}

class LogicalPuzzleGame {
  final List<Widget> questions = [
    // Level 1
    const Text(
      "2, 4, 8, 16, ?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),

    // Level 2 — TRIANGLE FEATURE
    // Level 2 — TRIANGLE FEATURE
// Level 2 — TRIANGLE FEATURE
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Smaller triangle (no scroll)
        CustomPaint(
          size: const Size(90, 90),
          painter: TriangularLatticePainter(divisions: 2),
        ),
        const SizedBox(height: 6),
        const Text("= 5", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        CustomPaint(
          size: const Size(120, 120),
          painter: TriangularLatticePainter(divisions: 3),
        ),
        const SizedBox(height: 6),
        const Text("= ?", style: TextStyle(fontSize: 16)),
      ],
    ),

    // Level 3
    const Text(
      "3, 10, 18, ?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),

    // Level 4
    const Text(
      "A + B = 100\nA - B = 60\nA / B = ?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),

    // Level 5
    const Text(
      "1, 2 = 2\n3, 5 = 15\n2, 7 = 14\n3, 8 = ?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),

    // Level 6 — GRID PUZZLE
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(90, 90),
          painter: GridBoxPainter(rows: 2, columns: 2),
        ),
        const SizedBox(height: 6),
        const Text("= 5", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        CustomPaint(
          size: const Size(120, 120),
          painter: GridBoxPainter(rows: 3, columns: 3),
        ),
        const SizedBox(height: 6),
        const Text("= ?", style: TextStyle(fontSize: 16)),
      ],
    ),

    // Level 7
    const Text(
      "5 = 30\n3 = 12\n8 = 72\n7 = ?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),

    // Level 8
    const Text(
      "2   1   0   0\n"
          "4   1   1   1\n"
          "6   1   0   2\n"
          "?   ?   ?   ?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),

    // Level 9 — UPSIDE-DOWN TRIANGLE PUZZLE
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UpsideDownTriangle(topLeft: 5, topRight: 10, bottom: 2),
            const SizedBox(width: 20),
            UpsideDownTriangle(topLeft: 4, topRight: 32, bottom: 8),
          ],
        ),
        const SizedBox(height: 16),
        UpsideDownTriangle(topLeft: 4, topRight: 20, bottom: null),
      ],
    ),

    // Level 10
    const Text(
      "7, 15, 31, ?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),

    // Level 11
    const Text(
      "1, 3, 5\n6, 8, 10\n1, ?, 7",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),

    // Level 12
    const Text(
      "1873, 3187, 7318, ?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),

    // Level 13
    const Text(
      "□ + □ = 8\n"
          "2○ + □ = 14\n"
          "△ + ○ = 11\n"
          "△ = ?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),

    // Level 14
    const Text(
      "A = 5\nD = 8\n      B + C = ?",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    ),

    // Level 15 — Aligned 3×3 grid puzzle
    Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FixedColumnWidth(64),
        1: FixedColumnWidth(64),
        2: FixedColumnWidth(64),
      },
      border: TableBorder.all(color: Colors.black, width: 1.5),
      children: [
        const TableRow(children: [
          _GridCell('49'),
          _GridCell('64'),
          _GridCell('1'),
        ]),
        const TableRow(children: [
          _GridCell('9'),
          _GridCell('?'),
          _GridCell('36'),
        ]),
        const TableRow(children: [
          _GridCell('81'),
          _GridCell('25'),
          _GridCell('16'),
        ]),
      ],
    )

  ];

  final List<String> answers = [
    "32",   // 1
    "13",   // 2
    "27",   // 3
    "4",    // 4
    "24",   // 5
    "14",   // 6
    "56",   // 7
    "8103", // 8
    "5",    // 9
    "63",   // 10
    "4",    // 11
    "8731", // 12
    "6",    // 13
    "13",    // 14
    "4",    // 15
  ];

  bool isCorrect(int levelIndex, String input) {
    return input.trim().toLowerCase() ==
        answers[levelIndex].toLowerCase();
  }

  int get totalLevels => questions.length;

  // ---------- Helpers ----------
  static Widget _triangleRow(int count) {
    return Wrap(
      spacing: 12,
      alignment: WrapAlignment.center,
      children: List.generate(
        count,
            (_) => CustomPaint(
          size: const Size(40, 35),
          painter: _TrianglePainter(),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = Colors.black;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
