// lib/team_report_page.dart
import 'package:flutter/material.dart';

const kBrand = Color(0xFF2F5B89);

class TeamReportPage extends StatelessWidget {
  const TeamReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = [
      _RowData("Team A (ER)", 86, 42, 98),
      _RowData("Team B (Surgery)", 78, 37, 94),
      _RowData("Team C (ICU)", 82, 25, 96),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          "Team Reports",
          style: TextStyle(
            color: kBrand,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Exported (demo).")),
              );
            },
            icon: const Icon(Icons.download_rounded, color: kBrand),
            label: const Text(
              "Export",
              style: TextStyle(color: kBrand, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Table container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0x11000000)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                children: [
                  // Header row
                  _HeaderRow(),
                  const Divider(height: 1),
                  // Data rows
                  ...rows.map((r) => _DataRowTile(data: r)).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const headStyle = TextStyle(
      fontWeight: FontWeight.w800,
      color: kBrand,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: const [
          Expanded(flex: 5, child: Text("Team", style: headStyle)),
          Expanded(flex: 2, child: Text("Avg", style: headStyle)),
          Expanded(flex: 2, child: Text("Attempts", style: headStyle)),
          Expanded(flex: 2, child: Text("Best", style: headStyle, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class _DataRowTile extends StatelessWidget {
  final _RowData data;
  const _DataRowTile({required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // مكان مستقبلي للتفاصيل
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                // Team name
                Expanded(
                  flex: 5,
                  child: Text(
                    data.team,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Avg badge
                Expanded(flex: 2, child: _badge(data.avg)),

                // Attempts number (right aligned)
                Expanded(
                  flex: 2,
                  child: Text(
                    "${data.attempts}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),

                // Best number (right aligned)
                Expanded(
                  flex: 2,
                  child: Text(
                    "${data.best}",
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Divider between rows (except last one will also look fine)
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  static Widget _badge(int v) {
    Color c;
    if (v >= 90) {
      c = const Color(0xFF2ECC71); // green
    } else if (v >= 75) {
      c = const Color(0xFFF1C40F); // yellow
    } else {
      c = const Color(0xFFE74C3C); // red
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: c.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: c.withOpacity(0.6)),
        ),
        child: Text(
          "$v",
          style: TextStyle(
            color: c,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _RowData {
  final String team;
  final int avg, attempts, best;
  _RowData(this.team, this.avg, this.attempts, this.best);
}
