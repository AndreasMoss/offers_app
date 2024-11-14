class Offer {
  Offer(
      {required this.id,
      required this.title,
      required this.description,
      required this.codes,
      required this.businessId,
      this.profileImage});

  final String id;
  final String title;
  final String description;
  final int codes;
  final String businessId;
  final String? profileImage;

  int redeemedCodes = 0;

  int get availableCodes {
    return codes - redeemedCodes;
  }

  void printOfferId() {
    print("OFFFFEEEEERRRR ID: ---------------$id------------------");
  }

  void redeemCode() {
    if (availableCodes > 0) {
      redeemedCodes++;
    } else {
      print('No Codes left');
    }
  }
}
