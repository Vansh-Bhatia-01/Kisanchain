import 'package:flutter/material.dart';
import '../core/models/farmer.dart';
import 'verification_screen.dart';

class FarmerFormScreen extends StatefulWidget {
  const FarmerFormScreen({super.key});

  @override
  State<FarmerFormScreen> createState() => _FarmerFormScreenState();
}

class _FarmerFormScreenState extends State<FarmerFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final landController = TextEditingController();
  final cropController = TextEditingController();
  final yieldController = TextEditingController();
  final incomeController = TextEditingController();

  String? landUnit;
  String? cropType;
  String? incomeBracket;

  final landUnits = [
    'Acres',
    'Hectares',
    'Bigha',
    'Biswa',
    'Guntha',
    'Kanal',
    'Marla',
    'Cent',
    'Square Feet',
  ];

  final crops = [
    'Wheat',
    'Rice',
    'Maize',
    'Cotton',
    'Sugarcane',
    'Other',
  ];

  final incomes = [
    'Below ₹1 Lakh',
    '₹1–3 Lakh',
    '₹3–5 Lakh',
    'Above ₹5 Lakh',
  ];

  double? get incomeLimit {
    switch (incomeBracket) {
      case 'Below ₹1 Lakh':
        return 100000;
      case '₹1–3 Lakh':
        return 300000;
      case '₹3–5 Lakh':
        return 500000;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    landController.dispose();
    cropController.dispose();
    yieldController.dispose();
    incomeController.dispose();
    super.dispose();
  }

  void submit() {
  if (!formKey.currentState!.validate() ||
      landUnit == null ||
      cropType == null ||
      incomeBracket == null) {
    setState(() {});
    return;
  }

  final farmer = Farmer(
    name: nameController.text.trim(),
    landSize: double.parse(landController.text),
    landUnit: landUnit!,
    cropType: cropType!,
    customCrop: cropType == 'Other'
        ? cropController.text.trim()
        : null,
    pastYield: double.parse(yieldController.text),
    incomeBracket: incomeBracket!,
    income: double.parse(incomeController.text),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => VerificationScreen(farmer: farmer),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Eligibility'),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Farmer Details',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your details to check subsidy eligibility.',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Enter your name'
                        : null,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: landController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Land Size',
                        prefixIcon: Icon(Icons.landscape_outlined),
                      ),
                      validator: (value) {
                        final number = double.tryParse(value ?? '');
                        if (number == null || number <= 0) {
                          return 'Enter valid land size';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: landUnit,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                      ),
                      items: landUnits
                          .map(
                            (unit) => DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => landUnit = value),
                      validator: (value) =>
                          value == null ? 'Select unit' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: cropType,
                decoration: const InputDecoration(
                  labelText: 'Crop Type',
                  prefixIcon: Icon(Icons.grass),
                ),
                items: crops
                    .map(
                      (crop) => DropdownMenuItem(
                        value: crop,
                        child: Text(crop),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    cropType = value;
                    if (value != 'Other') {
                      cropController.clear();
                    }
                  });
                },
                validator: (value) =>
                    value == null ? 'Select a crop' : null,
              ),
              if (cropType == 'Other') ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: cropController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'What are you sowing?',
                    prefixIcon: Icon(Icons.eco_outlined),
                  ),
                  validator: (value) {
                    if (cropType == 'Other' &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Mention what you are sowing';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),
              TextFormField(
                controller: yieldController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Past Yield',
                  suffixText: 'quintals',
                  prefixIcon: Icon(Icons.agriculture_outlined),
                ),
                validator: (value) {
                  final number = double.tryParse(value ?? '');
                  if (number == null || number < 0) {
                    return 'Enter a valid yield';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: incomeBracket,
                decoration: const InputDecoration(
                  labelText: 'Income Bracket',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                items: incomes
                    .map(
                      (income) => DropdownMenuItem(
                        value: income,
                        child: Text(income),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    incomeBracket = value;
                    incomeController.clear();
                  });
                },
                validator: (value) =>
                    value == null ? 'Select an income bracket' : null,
              ),
              if (incomeBracket != null) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: incomeController,
                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Exact / Approx. Annual Income',
                    prefixIcon: Icon(Icons.currency_rupee),
                    suffixText: 'per year',
                  ),
                  validator: (value) {
                    final income = double.tryParse(value ?? '');

                    if (income == null || income <= 0) {
                      return 'Enter a valid income';
                    }

                    if (incomeBracket == 'Below ₹1 Lakh' &&
                        income >= 100000) {
                      return 'Income must be below ₹1 Lakh';
                    }

                    if (incomeBracket == '₹1–3 Lakh' &&
                        (income < 100000 || income >= 300000)) {
                      return 'Income must be ₹1–3 Lakh';
                    }

                    if (incomeBracket == '₹3–5 Lakh' &&
                        (income < 300000 || income >= 500000)) {
                      return 'Income must be ₹3–5 Lakh';
                    }

                    if (incomeBracket == 'Above ₹5 Lakh' &&
                        income <= 500000) {
                      return 'Income must be above ₹5 Lakh';
                    }

                    return null;
                  },
                ),
              ],
              const SizedBox(height: 28),
              SizedBox(
                height: 54,
                child: FilledButton(
                  onPressed: submit,
                  child: const Text(
                    'Check Eligibility',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
}