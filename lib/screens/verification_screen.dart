import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../core/models/farmer.dart';
import 'result_screen.dart';

class VerificationScreen extends StatefulWidget {
  final Farmer farmer;

  const VerificationScreen({
    super.key,
    required this.farmer,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String? identityDocument;
  String? familyCard;
  String? landRecord;
  String? incomeProof;

  Future<String?> pickDocument() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    return files.isEmpty ? null : files.first.name;
  }

  Future<void> pickIdentity() async {
    final file = await pickDocument();
    if (file != null) {
      setState(() => identityDocument = file);
    }
  }

  Future<void> pickFamilyCard() async {
    final file = await pickDocument();
    if (file != null) {
      setState(() => familyCard = file);
    }
  }

  Future<void> pickLandRecord() async {
    final file = await pickDocument();
    if (file != null) {
      setState(() => landRecord = file);
    }
  }

  Future<void> pickIncomeProof() async {
    final file = await pickDocument();
    if (file != null) {
      setState(() => incomeProof = file);
    }
  }

  void continueToResult() {
    if (identityDocument == null ||
        familyCard == null ||
        landRecord == null ||
        incomeProof == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload all required documents'),
        ),
      );
      return;
    }

    final farmer = Farmer(
      name: widget.farmer.name,
      landSize: widget.farmer.landSize,
      landUnit: widget.farmer.landUnit,
      cropType: widget.farmer.cropType,
      customCrop: widget.farmer.customCrop,
      pastYield: widget.farmer.pastYield,
      incomeBracket: widget.farmer.incomeBracket,
      income: widget.farmer.income,
      identityDocument: identityDocument,
      familyCard: familyCard,
      landRecord: landRecord,
      incomeProof: incomeProof,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(farmer: farmer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Verification'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Verify Your Details',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload documents to support the information you provided.',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          _documentCard(
            title: 'Identity Document',
            subtitle: 'Government identity document',
            fileName: identityDocument,
            onTap: pickIdentity,
            icon: Icons.badge_outlined,
          ),
          _documentCard(
            title: 'Family / Household Card',
            subtitle: 'Family or household document',
            fileName: familyCard,
            onTap: pickFamilyCard,
            icon: Icons.family_restroom,
          ),
          _documentCard(
            title: 'Land Record',
            subtitle: 'Proof of land ownership or holding',
            fileName: landRecord,
            onTap: pickLandRecord,
            icon: Icons.landscape_outlined,
          ),
          _documentCard(
            title: 'Income Proof',
            subtitle: 'Supporting income document',
            fileName: incomeProof,
            onTap: pickIncomeProof,
            icon: Icons.receipt_long_outlined,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Documents submitted here are pending verification. Uploading a document does not mean government verification has been completed.',
                    style: TextStyle(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: continueToResult,
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentCard({
    required String title,
    required String subtitle,
    required String? fileName,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    final uploaded = fileName != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          uploaded ? fileName : subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          uploaded
              ? Icons.check_circle
              : Icons.upload_file_outlined,
        ),
        onTap: onTap,
      ),
    );
  }
}