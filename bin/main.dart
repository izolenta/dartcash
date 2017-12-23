import 'package:dartcash/utils/crypto_utils.dart';

main(List<String> arguments) {
  for (int i=0; i<1000; i++) {
    final keyPair = CryptoUtils.generateKeyPair();
    var address = CryptoUtils.createDartCashAddress(keyPair.publicKey);
    print(address);
    print(CryptoUtils.checkDartCashAddress(address));
  }
}
