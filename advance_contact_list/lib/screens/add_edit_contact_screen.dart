import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';

class AddEditContactScreen extends StatefulWidget {
  final Contact? contact; // Null for Add mode, non-null for Edit mode

  const AddEditContactScreen({super.key, this.contact});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _companyController;
  late TextEditingController _jobController;
  late TextEditingController _linkedinController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;

  ContactCategory _selectedCategory = ContactCategory.developer;
  DateTime? _selectedBirthday;
  bool _isFavorite = false;
  int _selectedColorIndex = 0;

  @override
  void initState() {
    super.initState();
    final c = widget.contact;
    _nameController = TextEditingController(text: c?.name ?? '');
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _companyController = TextEditingController(text: c?.company ?? '');
    _jobController = TextEditingController(text: c?.jobTitle ?? '');
    _linkedinController = TextEditingController(text: c?.linkedin ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _notesController = TextEditingController(text: c?.notes ?? '');

    if (c != null) {
      _selectedCategory = c.category;
      _selectedBirthday = c.birthday;
      _isFavorite = c.isFavorite;
      _selectedColorIndex = c.colorIndex;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _jobController.dispose();
    _linkedinController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.contact != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Contact' : 'Add New Contact'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Color Selector Preview
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: Contact(
                            id: '',
                            name: _nameController.text.isEmpty ? 'NC' : _nameController.text,
                            phone: '',
                            colorIndex: _selectedColorIndex,
                          ).avatarGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _nameController.text.trim().isNotEmpty
                              ? (_nameController.text.trim().split(' ').length >= 2
                                  ? '${_nameController.text.trim().split(' ')[0][0]}${_nameController.text.trim().split(' ')[1][0]}'
                                  : _nameController.text.trim()[0])
                              : 'NC',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('Choose Color Theme', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        final colors = Contact(id: '', name: '', phone: '', colorIndex: index).avatarGradient;
                        final isSelected = _selectedColorIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColorIndex = index;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: colors),
                              border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                              boxShadow: isSelected
                                  ? [BoxShadow(color: colors[0].withValues(alpha: 0.5), blurRadius: 8)]
                                  : null,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Full Name Input
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: Icon(Icons.person),
                ),
                onChanged: (_) => setState(() {}),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Full name is required';
                  }
                  if (val.trim().length < 2) {
                    return 'Name must be at least 2 characters long';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Phone Number Input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number * (10 Digits)',
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'e.g. 9876543210',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  final cleanPhone = val.replaceAll(RegExp(r'[^\d]'), '');
                  if (cleanPhone.length != 10 && !(cleanPhone.length == 12 && cleanPhone.startsWith('91'))) {
                    return 'Enter a valid 10-digit phone number (e.g. 9876543210)';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Email Address
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  hintText: 'e.g. name@gmail.com',
                ),
                validator: (val) {
                  if (val != null && val.trim().isNotEmpty) {
                    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(val.trim())) {
                      return 'Enter a valid email address (e.g. name@gmail.com)';
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // LinkedIn Profile
              TextFormField(
                controller: _linkedinController,
                decoration: const InputDecoration(
                  labelText: 'LinkedIn Profile / Username',
                  prefixIcon: Icon(Icons.work),
                  hintText: 'e.g. in/rahulsharma',
                ),
              ),

              const SizedBox(height: 16),

              // Company & Job Title Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _companyController,
                      decoration: const InputDecoration(
                        labelText: 'Company',
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _jobController,
                      decoration: const InputDecoration(
                        labelText: 'Job Title',
                        prefixIcon: Icon(Icons.badge),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Category Selector Dropdown
              DropdownButtonFormField<ContactCategory>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category Tag',
                  prefixIcon: Icon(Icons.label),
                ),
                items: const [
                  DropdownMenuItem(value: ContactCategory.developer, child: Text('👨‍💻 Developer')),
                  DropdownMenuItem(value: ContactCategory.family, child: Text('👨‍👩‍👧 Family')),
                  DropdownMenuItem(value: ContactCategory.friends, child: Text('🤝 Friends')),
                  DropdownMenuItem(value: ContactCategory.vip, child: Text('🏆 VIP')),
                  DropdownMenuItem(value: ContactCategory.intern, child: Text('🎓 Intern')),
                  DropdownMenuItem(value: ContactCategory.other, child: Text('🏷️ Other')),
                ],
                onChanged: (cat) {
                  if (cat != null) setState(() => _selectedCategory = cat);
                },
              ),

              const SizedBox(height: 16),

              // Birthday Picker Field
              InkWell(
                onTap: _pickBirthday,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Birthday',
                    prefixIcon: Icon(Icons.cake),
                  ),
                  child: Text(
                    _selectedBirthday != null
                        ? '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}'
                        : 'Select Birthday Date',
                    style: TextStyle(
                      color: _selectedBirthday != null ? null : Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Address Field
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),

              const SizedBox(height: 16),

              // Notes Text Area
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Personal Notes',
                  prefixIcon: Icon(Icons.notes),
                ),
              ),

              const SizedBox(height: 16),

              // Favorite Checkbox Switch
              SwitchListTile(
                title: const Row(
                  children: [
                    Icon(Icons.star, color: Color(0xFFF59E0B)),
                    SizedBox(width: 8),
                    Text('Mark as Pinned Favorite'),
                  ],
                ),
                value: _isFavorite,
                onChanged: (val) => setState(() => _isFavorite = val),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(isEdit ? 'Update Contact' : 'Save Contact'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _saveForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime(1998, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final service = ContactService();
      final isEdit = widget.contact != null;

      final newContact = Contact(
        id: isEdit ? widget.contact!.id : DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        company: _companyController.text.trim(),
        jobTitle: _jobController.text.trim(),
        linkedin: _linkedinController.text.trim(),
        category: _selectedCategory,
        birthday: _selectedBirthday,
        address: _addressController.text.trim(),
        notes: _notesController.text.trim(),
        isFavorite: _isFavorite,
        colorIndex: _selectedColorIndex,
      );

      if (isEdit) {
        await service.updateContact(newContact);
      } else {
        await service.addContact(newContact);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? 'Contact updated & saved permanently!' : 'New contact saved permanently!'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    }
  }
}
