import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class BookingSection extends StatefulWidget {
  const BookingSection({super.key});

  @override
  State<BookingSection> createState() => _BookingSectionState();
}

class _BookingSectionState extends State<BookingSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 2));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0);
  int _guests = 2;
  String _occasion = 'Dinner Dining';

  final List<String> _occasions = [
    'Dinner Dining',
    'Birthday Party',
    'Rooftop Nightlife & DJ',
    'Anniversary Special',
    'Corporate Gathering',
  ];

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryGold,
              onPrimary: Colors.black,
              surface: AppTheme.cardDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryGold,
              onPrimary: Colors.black,
              surface: AppTheme.cardDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      final dateStr = DateFormat('EEE, dd MMM yyyy').format(_selectedDate);
      final timeStr = _selectedTime.format(context);

      final message = 'Hello Upper Deck Restro! I want to book a table:\n'
          '👤 Name: ${_nameController.text.trim()}\n'
          '📞 Phone: ${_phoneController.text.trim()}\n'
          '📅 Date: $dateStr\n'
          '⏰ Time: $timeStr\n'
          '👥 Guests: $_guests\n'
          '🎉 Occasion: $_occasion\n'
          '📝 Note: ${_notesController.text.trim()}';

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.cardDarkElevated,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: AppTheme.primaryGold, size: 28),
              const SizedBox(width: 10),
              Text(
                'Booking Request Ready!',
                style: GoogleFonts.poppins(color: AppTheme.primaryGold, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thank you, ${_nameController.text.trim()}! Your table reservation details:',
                style: GoogleFonts.poppins(color: AppTheme.textWhite, fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.darkBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Text(
                  message,
                  style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 13, height: 1.5),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: GoogleFonts.poppins(color: AppTheme.textMuted)),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                final whatsappUrl = Uri.parse('https://wa.me/917800698999?text=${Uri.encodeComponent(message)}');
                if (await canLaunchUrl(whatsappUrl)) {
                  await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                }
              },
              icon: const Icon(Icons.send_rounded, size: 16),
              label: const Text('Send via WhatsApp'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.whatsappGreen,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 850;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: AppTheme.darkBackground,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Text(
                'RESERVATION',
                style: GoogleFonts.poppins(
                  color: AppTheme.primaryGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Book a Table at Upper Deck Restro',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              const SizedBox(height: 16),
              Container(width: 60, height: 3, color: AppTheme.primaryGold),
              const SizedBox(height: 40),

              Container(
                padding: EdgeInsets.all(isDesktop ? 40 : 24),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.primaryGold.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryGold.withOpacity(0.08),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name & Phone Row
                      isDesktop
                          ? Row(
                              children: [
                                Expanded(child: _buildNameInput()),
                                const SizedBox(width: 20),
                                Expanded(child: _buildPhoneInput()),
                              ],
                            )
                          : Column(
                              children: [
                                _buildNameInput(),
                                const SizedBox(height: 20),
                                _buildPhoneInput(),
                              ],
                            ),
                      const SizedBox(height: 20),

                      // Email & Occasion Row
                      isDesktop
                          ? Row(
                              children: [
                                Expanded(child: _buildEmailInput()),
                                const SizedBox(width: 20),
                                Expanded(child: _buildOccasionDropdown()),
                              ],
                            )
                          : Column(
                              children: [
                                _buildEmailInput(),
                                const SizedBox(height: 20),
                                _buildOccasionDropdown(),
                              ],
                            ),
                      const SizedBox(height: 20),

                      // Date, Time, Guests Pickers
                      isDesktop
                          ? Row(
                              children: [
                                Expanded(child: _buildDatePickerTile()),
                                const SizedBox(width: 16),
                                Expanded(child: _buildTimePickerTile()),
                                const SizedBox(width: 16),
                                Expanded(child: _buildGuestCounter()),
                              ],
                            )
                          : Column(
                              children: [
                                _buildDatePickerTile(),
                                const SizedBox(height: 16),
                                _buildTimePickerTile(),
                                const SizedBox(height: 16),
                                _buildGuestCounter(),
                              ],
                            ),
                      const SizedBox(height: 20),

                      // Notes Input
                      TextFormField(
                        controller: _notesController,
                        style: GoogleFonts.poppins(color: AppTheme.textWhite),
                        maxLines: 3,
                        decoration: _inputDecoration('Special Requests / Seating Preference (Optional)', Icons.notes),
                      ),
                      const SizedBox(height: 36),

                      // Submit Button
                      SizedBox(
                        width: isDesktop ? 300 : double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: _submitBooking,
                          icon: const Icon(Icons.bookmark_added_rounded, size: 22),
                          label: const Text('CONFIRM TABLE RESERVATION'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryGold,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return TextFormField(
      controller: _nameController,
      style: GoogleFonts.poppins(color: AppTheme.textWhite),
      validator: (val) => (val == null || val.trim().isEmpty) ? 'Please enter your name' : null,
      decoration: _inputDecoration('Your Full Name *', Icons.person_outline),
    );
  }

  Widget _buildPhoneInput() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: GoogleFonts.poppins(color: AppTheme.textWhite),
      validator: (val) => (val == null || val.trim().length < 10) ? 'Enter a valid 10-digit phone number' : null,
      decoration: _inputDecoration('Phone Number *', Icons.phone_outlined),
    );
  }

  Widget _buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.poppins(color: AppTheme.textWhite),
      decoration: _inputDecoration('Email Address (Optional)', Icons.email_outlined),
    );
  }

  Widget _buildOccasionDropdown() {
    return DropdownButtonFormField<String>(
      value: _occasion,
      dropdownColor: AppTheme.cardDarkElevated,
      style: GoogleFonts.poppins(color: AppTheme.textWhite),
      decoration: _inputDecoration('Dining Occasion', Icons.celebration_outlined),
      items: _occasions.map((occ) {
        return DropdownMenuItem(
          value: occ,
          child: Text(occ),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) setState(() => _occasion = val);
      },
    );
  }

  Widget _buildDatePickerTile() {
    final dateStr = DateFormat('MMM dd, yyyy').format(_selectedDate);
    return InkWell(
      onTap: _selectDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.cardDarkElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, color: AppTheme.primaryGold, size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date', style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 11)),
                Text(dateStr, style: GoogleFonts.poppins(color: AppTheme.textWhite, fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePickerTile() {
    final timeStr = _selectedTime.format(context);
    return InkWell(
      onTap: _selectTime,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.cardDarkElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time_outlined, color: AppTheme.primaryGold, size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Time', style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 11)),
                Text(timeStr, style: GoogleFonts.poppins(color: AppTheme.textWhite, fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardDarkElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.group_outlined, color: AppTheme.primaryGold, size: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Guests', style: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 11)),
                  Text('$_guests People', style: GoogleFonts.poppins(color: AppTheme.textWhite, fontWeight: FontWeight.w600, fontSize: 14)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _guests > 1 ? () => setState(() => _guests--) : null,
                icon: const Icon(Icons.remove_circle_outline, size: 20, color: AppTheme.primaryGold),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _guests < 25 ? () => setState(() => _guests++) : null,
                icon: const Icon(Icons.add_circle_outline, size: 20, color: AppTheme.primaryGold),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.poppins(color: AppTheme.textMuted, fontSize: 13),
      prefixIcon: Icon(icon, color: AppTheme.primaryGold, size: 20),
      filled: true,
      fillColor: AppTheme.cardDarkElevated,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primaryGold),
      ),
    );
  }
}
