class Farmer {
  final String name;
  final double landSize;
  final String landUnit;
  final String cropType;
  final String? customCrop;
  final double pastYield;
  final String incomeBracket;
  final double income;
  final String? identityDocument;
  final String? familyCard;
  final String? landRecord;
  final String? incomeProof;

  const Farmer({
    required this.name,
    required this.landSize,
    required this.landUnit,
    required this.cropType,
    required this.customCrop,
    required this.pastYield,
    required this.incomeBracket,
    required this.income,
    this.identityDocument,
    this.familyCard,
    this.landRecord,
    this.incomeProof,
  });

  double get landInAcres {
    const conversion = {
      'Acres': 1.0,
      'Hectares': 2.47105,
      'Bigha': 0.625,
      'Biswa': 0.03125,
      'Guntha': 0.025,
      'Kanal': 0.125,
      'Marla': 0.00625,
      'Cent': 0.01,
      'Square Feet': 0.0000229568,
    };

    return landSize * (conversion[landUnit] ?? 1);
  }

  String get sowingCrop {
    return cropType == 'Other' ? (customCrop ?? '') : cropType;
  }

  bool get documentsComplete {
    return identityDocument != null &&
        familyCard != null &&
        landRecord != null &&
        incomeProof != null;
  }
}