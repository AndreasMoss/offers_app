class Offer {
  Offer(
      {required this.id,
      required this.title,
      required this.description,
      required this.codes});

  final String id;
  final String title;
  final String description;
  final int codes;

  int redeemedCodes = 0;

  int get availableCodes {
    return codes - redeemedCodes;
  }

  void redeemCode() {
    if (availableCodes > 0) {
      redeemedCodes++;
    } else
      print('No Codes left');
  }
}
