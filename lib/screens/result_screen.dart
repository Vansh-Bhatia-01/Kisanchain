import 'package:flutter/material.dart';
import '../core/models/farmer.dart';
import '../services/api_service.dart';

class ResultScreen extends StatefulWidget {
  final Farmer farmer;

  const ResultScreen({
    super.key,
    required this.farmer,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, dynamic>? result;
  String? error;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    checkEligibility();
  }

  Future<void> checkEligibility() async {
    try {
      final response = await ApiService.checkEligibility(widget.farmer);

      if (!mounted) return;

      setState(() {
        result = response;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        error = 'Unable to connect to eligibility server';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              loading = true;
                              error = null;
                            });
                            checkEligibility();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _result(),
    );
  }

  Widget _result() {
    final score = result!['score'] as int;
    final approved = result!['approved'] as bool;
    final amount = result!['amount'] as int;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Icon(
          approved
              ? Icons.check_circle_outline
              : Icons.cancel_outlined,
          size: 72,
        ),
        const SizedBox(height: 16),
        Text(
          approved ? 'Eligible' : 'Not Eligible',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.farmer.name,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        _card(
          title: 'Eligibility Score',
          child: Column(
            children: [
              Text(
                '$score / 100',
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                approved
                    ? 'Application approved'
                    : 'Application not approved',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _card(
          title: 'Estimated Subsidy',
          child: Text(
            '₹$amount',
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _card(
          title: 'Verification',
          child: Column(
            children: [
              _status('Identity Document'),
              _status('Family / Household Card'),
              _status('Land Record'),
              _status('Income Proof'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _card(
          title: 'Farmer Details',
          child: Column(
            children: [
              _row('Land', '${widget.farmer.landSize} ${widget.farmer.landUnit}'),
              _row('Crop', widget.farmer.sowingCrop),
              _row('Past Yield', '${widget.farmer.pastYield} quintals'),
              _row('Income', '₹${widget.farmer.income.toStringAsFixed(0)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card({
    required String title,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(child: child),
          ],
        ),
      ),
    );
  }

  Widget _status(String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.check_circle_outline),
      title: Text(title),
      trailing: const Text('Pending'),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}