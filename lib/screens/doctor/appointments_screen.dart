import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedTimeSlot;

  final List<String> _timeSlots = ['10.00 AM', '11.00 AM', '12.00 PM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with curved background
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD5E1F0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Text(
                        'VRVITA',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A6FA5),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Title
            const Text(
              'VR Upcoming\nAppointments',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Date And Time',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    // Calendar
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Month Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: () {
                                  setState(() {
                                    _focusedDay = DateTime(
                                      _focusedDay.year,
                                      _focusedDay.month - 1,
                                    );
                                  });
                                },
                              ),
                              Text(
                                '${_getMonthName(_focusedDay.month)} ${_focusedDay.year}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: () {
                                  setState(() {
                                    _focusedDay = DateTime(
                                      _focusedDay.year,
                                      _focusedDay.month + 1,
                                    );
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Week days header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:
                                [
                                      'SUN',
                                      'MON',
                                      'TUE',
                                      'WED',
                                      'THU',
                                      'FRI',
                                      'SAT',
                                    ]
                                    .map(
                                      (day) => SizedBox(
                                        width: 40,
                                        child: Text(
                                          day,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: 12),
                          // Calendar Grid
                          _buildCalendarGrid(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Available Time Slot
                    const Text(
                      'Available Time Slot',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Time Slots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _timeSlots.map((time) {
                        final isSelected = _selectedTimeSlot == time;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTimeSlot = time;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF4A6FA5)
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF4A6FA5)
                                    : Colors.grey[300]!,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              time,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 40),

                    // Set Appointment Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _selectedTimeSlot != null
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Appointment set successfully!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A6FA5),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          disabledBackgroundColor: Colors.grey[300],
                          elevation: 0,
                        ),
                        child: const Text(
                          'Set Appointment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startingWeekday = firstDayOfMonth.weekday % 7;

    List<Widget> dayWidgets = [];

    // Empty cells for days before month starts
    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(const SizedBox(width: 40, height: 40));
    }

    // Days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(_focusedDay.year, _focusedDay.month, day);
      final isSelected =
          _selectedDay.year == currentDate.year &&
          _selectedDay.month == currentDate.month &&
          _selectedDay.day == currentDate.day;

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedDay = currentDate;
            });
          },
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4A6FA5) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(alignment: WrapAlignment.spaceAround, children: dayWidgets);
  }
}
