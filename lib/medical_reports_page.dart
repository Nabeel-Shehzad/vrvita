import 'package:flutter/material.dart';

const kBrand = Color(0xFF2F5B89);

class MedicalReportsPage extends StatefulWidget {
  const MedicalReportsPage({super.key});

  @override
  State<MedicalReportsPage> createState() => _MedicalReportsPageState();
}

class _MedicalReportsPageState extends State<MedicalReportsPage> {
  String _dateFilter = "Week";     // Today / Week / Month / All
  String _typeFilter = "All";      // All / Labs / Imaging / Notes
  String _query = "";

  final List<_Report> _all = [
    _Report("LAB-2456", "Labs", "Ali Hassan", DateTime.now().subtract(const Duration(hours: 5)), "Normal"),
    _Report("IMG-8012", "Imaging", "Sara Ahmed", DateTime.now().subtract(const Duration(days: 1)), "Review"),
    _Report("NOTE-112", "Notes", "Mohammed Z.", DateTime.now().subtract(const Duration(days: 3)), "Follow-up"),
    _Report("LAB-2489", "Labs", "Nada Saleh", DateTime.now().subtract(const Duration(days: 9)), "Urgent"),
  ];

  List<String> get _dateFilters => const ["Today", "Week", "Month", "All"];
  List<String> get _typeFilters => const ["All", "Labs", "Imaging", "Notes"];

  List<_Report> get _filtered {
    final now = DateTime.now();
    final start = () {
      switch (_dateFilter) {
        case "Today":
          return DateTime(now.year, now.month, now.day);
        case "Week":
          return now.subtract(const Duration(days: 7));
        case "Month":
          return now.subtract(const Duration(days: 30));
        default:
          return DateTime(2000);
      }
    }();

    return _all.where((r) {
      final inDate = r.date.isAfter(start);
      final inType = _typeFilter == "All" || r.type == _typeFilter;
      final inQuery = _query.isEmpty ||
          r.id.toLowerCase().contains(_query) ||
          r.patient.toLowerCase().contains(_query) ||
          r.status.toLowerCase().contains(_query);
      return inDate && inType && inQuery;
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void _export() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Export started… (hook your backend here)"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: kBrand,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Medical Reports", style: TextStyle(color: kBrand, fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: kBrand),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _export,
            icon: const Icon(Icons.file_download_rounded, color: kBrand),
            label: const Text("Export", style: TextStyle(color: kBrand, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          // 🔎 Search
          TextField(
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            decoration: InputDecoration(
              hintText: "Search by patient, report ID, status…",
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: const Color(0xFFF4F6FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),

          // Filters row
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _dateFilters.map((f) {
                    final sel = _dateFilter == f;
                    return ChoiceChip(
                      label: Text(f),
                      selected: sel,
                      selectedColor: kBrand,
                      labelStyle: TextStyle(color: sel ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
                      onSelected: (_) => setState(() => _dateFilter = f),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Type chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _typeFilters.map((f) {
              final sel = _typeFilter == f;
              return FilterChip(
                label: Text(f),
                selected: sel,
                selectedColor: kBrand.withOpacity(.12),
                checkmarkColor: kBrand,
                onSelected: (_) => setState(() => _typeFilter = f),
                shape: StadiumBorder(side: BorderSide(color: sel ? kBrand : const Color(0x22000000))),
                labelStyle: TextStyle(
                  color: sel ? kBrand : Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // List
          if (items.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x11000000)),
              ),
              child: const Center(
                child: Text("No reports match your filters.", style: TextStyle(color: Colors.black54)),
              ),
            )
          else
            ...items.map((r) => _ReportTile(r: r)).toList(),
        ],
      ),
    );
  }
}

// ===== Models & Tiles =====

class _Report {
  final String id;
  final String type;   // Labs / Imaging / Notes
  final String patient;
  final DateTime date;
  final String status; // Normal / Review / Urgent / Follow-up

  _Report(this.id, this.type, this.patient, this.date, this.status);
}

class _ReportTile extends StatelessWidget {
  final _Report r;
  const _ReportTile({required this.r});

  @override
  Widget build(BuildContext context) {
    final color = () {
      switch (r.status.toLowerCase()) {
        case "urgent": return Colors.red.shade600;
        case "review": return Colors.orange.shade700;
        case "follow-up": return Colors.blueGrey.shade700;
        default: return Colors.green.shade600;
      }
    }();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0x11000000)),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: kBrand.withOpacity(.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              r.type == "Labs"
                  ? Icons.biotech_rounded
                  : r.type == "Imaging"
                  ? Icons.medical_information_rounded
                  : Icons.note_alt_rounded,
              color: kBrand,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _TwoLines(
              title: "${r.id} • ${r.type}",
              subtitle: "${r.patient} • ${_fmt(r.date)}",
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color),
            ),
            child: Text(r.status, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Open ${r.id} details…'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: kBrand,
                ),
              );
            },
            icon: const Icon(Icons.open_in_new_rounded, color: kBrand),
            tooltip: "View",
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      "${_pad(d.day)}/${_pad(d.month)}/${d.year}  ${_pad(d.hour)}:${_pad(d.minute)}";

  String _pad(int n) => n.toString().padLeft(2, '0');
}

class _TwoLines extends StatelessWidget {
  final String title;
  final String subtitle;
  const _TwoLines({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
