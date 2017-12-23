import 'package:dartcash/utils/crypto_utils.dart';

class DartCashAddress {

  String _addressString;

  DartCashAddress.createNew() {
    final keyPair = CryptoUtils.generateKeyPair();
    _addressString = CryptoUtils.createDartCashAddress(keyPair.publicKey);
  }

  DartCashAddress.fromString(String address) {
    try {
      CryptoUtils.checkDartCashAddress(address);
      _addressString = address;
    }
    catch (e) {
      throw new FormatException("$address is not valid DartCash address");
    }
  }

  @override
  String toString() {
    return _addressString;
  }
}