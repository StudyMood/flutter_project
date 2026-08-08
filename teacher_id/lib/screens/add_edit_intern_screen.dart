import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/intern_model.dart';
import '../providers/intern_provider.dart';
import '../themes/app_theme.dart';
import '../widgets/glass_container.dart';

class AddEditInternScreen extends StatefulWidget {
  final InternModel? internToEdit;

  const AddEditInternScreen({super.key, this.internToEdit});

  @override
  State<AddEditInternScreen> createState() => _AddEditInternScreenState();
}

class _AddEditInternScreenState extends State<AddEditInternScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _internIdController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _joiningDateController;
  late TextEditingController _collegeController;
  late TextEditingController _addressController;
  late TextEditingController _imageUrlController;

  String _selectedTechnology = 'Flutter';
  String _selectedStatus = 'Active';

  final List<String> technologies = [
    'Flutter',
    'PHP',
    'Python',
    'Java',
    'MERN Stack',
    'Digital Marketing',
    'UI/UX',
    'AI/ML',
    'Data Science',
    'Cyber Security',
  ];

  @override
  void initState() {
    super.initState();

    final isEditing = widget.internToEdit != null;
    final provider = Provider.of<InternProvider>(context, listen: false);

    _fullNameController = TextEditingController(text: isEditing ? widget.internToEdit!.fullName : '');
    _internIdController = TextEditingController(
      text: isEditing ? widget.internToEdit!.internId : provider.generateNextInternId(),
    );
    _emailController = TextEditingController(text: isEditing ? widget.internToEdit!.email : '');
    _phoneController = TextEditingController(text: isEditing ? widget.internToEdit!.phone : '');
    _joiningDateController = TextEditingController(
      text: isEditing ? widget.internToEdit!.joiningDate : DateFormat('dd MMM yyyy').format(DateTime.now()),
    );
    _collegeController = TextEditingController(text: isEditing ? widget.internToEdit!.college : '');
    _addressController = TextEditingController(text: isEditing ? widget.internToEdit!.address : '');
    _imageUrlController = TextEditingController(
      text: isEditing
          ? widget.internToEdit!.image
          : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=400',
    );

    if (isEditing) {
      if (technologies.contains(widget.internToEdit!.technology)) {
        _selectedTechnology = widget.internToEdit!.technology;
      }
      _selectedStatus = widget.internToEdit!.status;
    }
  }

  void _selectJoiningDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _joiningDateController.text = DateFormat('dd MMM yyyy').format(picked);
      });
    }
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<InternProvider>(context, listen: false);
    final isEditing = widget.internToEdit != null;

    final internData = InternModel(
      id: isEditing ? widget.internToEdit!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: _fullNameController.text.trim(),
      internId: _internIdController.text.trim(),
      image: _imageUrlController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      joiningDate: _joiningDateController.text.trim(),
      technology: _selectedTechnology,
      college: _collegeController.text.trim(),
      address: _addressController.text.trim(),
      status: _selectedStatus,
      qrCode: _internIdController.text.trim(),
      barcode: _internIdController.text.trim(),
      createdAt: isEditing ? widget.internToEdit!.createdAt : DateTime.now(),
    );

    if (isEditing) {
      provider.updateIntern(internData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Intern updated successfully!'), backgroundColor: AppTheme.secondaryGreen),
      );
    } else {
      provider.addIntern(internData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New Intern added successfully!'), backgroundColor: AppTheme.secondaryGreen),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.internToEdit != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Intern Profile' : 'Add New Intern'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GlassContainer(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Banner
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryOrange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.person_add_rounded, color: AppTheme.primaryOrange, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Update Details' : 'Registration Form',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        const Text(
                          'DigiCoders Digital ID Generation System',
                          style: TextStyle(fontSize: 11, color: AppTheme.secondaryGreen),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Intern ID (Auto generated & read only or editable)
                TextFormField(
                  controller: _internIdController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Intern ID (Auto Generated)',
                    prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.primaryOrange),
                    filled: true,
                  ),
                ),

                const SizedBox(height: 14),

                // Full Name
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name *',
                    prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryOrange),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Enter full name' : null,
                ),

                const SizedBox(height: 14),

                // Email & Phone Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email *',
                          prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primaryOrange),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Enter email' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Contact Phone *',
                          prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primaryOrange),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Enter phone' : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Technology & Status Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedTechnology,
                        decoration: const InputDecoration(
                          labelText: 'Technology *',
                          prefixIcon: Icon(Icons.memory_rounded, color: AppTheme.primaryOrange),
                        ),
                        items: technologies.map((tech) {
                          return DropdownMenuItem(value: tech, child: Text(tech));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedTechnology = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status *',
                          prefixIcon: Icon(Icons.check_circle_outline, color: AppTheme.secondaryGreen),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Active', child: Text('Active')),
                          DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedStatus = val);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Joining Date Picker
                TextFormField(
                  controller: _joiningDateController,
                  readOnly: true,
                  onTap: _selectJoiningDate,
                  decoration: const InputDecoration(
                    labelText: 'Joining Date *',
                    prefixIcon: Icon(Icons.calendar_today_rounded, color: AppTheme.primaryOrange),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),

                const SizedBox(height: 14),

                // College Name
                TextFormField(
                  controller: _collegeController,
                  decoration: const InputDecoration(
                    labelText: 'College / University *',
                    prefixIcon: Icon(Icons.school_outlined, color: AppTheme.primaryOrange),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Enter college name' : null,
                ),

                const SizedBox(height: 14),

                // Address
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on_outlined, color: AppTheme.primaryOrange),
                  ),
                ),

                const SizedBox(height: 14),

                // Photo URL / Image Field
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Passport Photo Image URL',
                    prefixIcon: Icon(Icons.image_outlined, color: AppTheme.primaryOrange),
                    hintText: 'https://...',
                  ),
                ),

                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton.icon(
                  onPressed: _saveForm,
                  icon: const Icon(Icons.save_rounded),
                  label: Text(isEditing ? 'Save Changes' : 'Generate Digital ID Card'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
