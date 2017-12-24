import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:bignum/bignum.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:collection/collection.dart';

class CryptoUtils {

  static const String alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz";

  static final int address_checksum_bytes = 4;
  static final String address_prefix = "DC";
  static final String domain_name = "secp256k1";
  static final String signer_algorithm = "SHA-1/DET-ECDSA";
  static final BigInteger BIG_INT_58 = new BigInteger("58");
  static final Function eq = const ListEquality().equals;

  static AsymmetricKeyPair generateKeyPair() {
    var rsapars = new ECKeyGeneratorParameters(new ECDomainParameters(domain_name));
    var secureRandom = new SecureRandom("Fortuna");

    var random = new Random();
    var seeds = [];
    for (int i = 0; i < 32; i++) {
      seeds.add(random.nextInt(255));
    }
    secureRandom.seed(new KeyParameter(new Uint8List.fromList(seeds)));

    var params = new ParametersWithRandom(rsapars, secureRandom);
    var keyGenerator = new KeyGenerator("EC")
      ..init( params )
    ;

    var keyPair = keyGenerator.generateKeyPair();
    return keyPair;
//    var cipher = new AsymmetricBlockCipher("RSA")
//      ..init( true, new PublicKeyParameter(keyPair.publicKey) )
//    ;
//    var cipherText = cipher.process(new Uint8List.fromList("Hello World".codeUnits));
//
//    print("Encrypted: ${new String.fromCharCodes(cipherText)}");
//
//    cipher = new AsymmetricBlockCipher("RSA")
//      ..init( false, new PrivateKeyParameter(keyPair.privateKey) )
//    ;
//    var decrypted = cipher.process(cipherText);
//    print("Decrypted: ${new String.fromCharCodes(decrypted)}");
  }

  static String signContent(String content, ECPrivateKey privateKey) {
    final signer = new Signer(signer_algorithm);
    signer.init(true, new PrivateKeyParameter(privateKey));
    final signature = signer.generateSignature(new Uint8List.fromList(content.codeUnits)) as ECSignature;
    return "${signature.r},${signature.s}";
  }

  static String createDartCashAddress(ECPublicKey publicKey) {
    final hash = crypto.sha256.convert(ecPublicKeyToString(publicKey).codeUnits).bytes.toList();
    final checksum = _getCheckSum(hash);
    hash.addAll(checksum);
    return "$address_prefix${_encodeBase58(hash)}";
  }

  static String _encodeBase58(List<int> array) {
    BigInteger intData = new BigInteger.fromBytes(1, array);
    String result = "";
    while (intData.compareTo(0) > 0)
    {
      int remainder = intData.modInt(58);
      intData = intData / BIG_INT_58;
      result = alphabet[remainder] + result;
    }

    for (int i = 0; i < array.length && array[i] == 0; i++)
    {
      result = '1' + result;
    }
    return result;
  }

  static List<int> _decodeBase58(String s) {
    BigInteger intData = new BigInteger.fromBytes(1, [0]);
    for (int i = 0; i < s.length; i++)
    {
      int digit = alphabet.indexOf(s[i]); //Slow
      if (digit < 0)
        throw new FormatException("Invalid Base58 character '${s[i]}' at position $i");
      intData = intData * BIG_INT_58 + new BigInteger(digit);
    }

    var leadingZeroCount = s.runes.takeWhile((rune) => new AsciiDecoder().convert([rune]) == '1').length;
    var result = new List.filled(leadingZeroCount, 0, growable: true);
    var bigIntArray = intData.toByteArray();
    for (int i=0; i<bigIntArray.length; i++) {
      if (bigIntArray[i] < 0) {
        bigIntArray[i] += 256;
      }
    }
    var bytesWithoutLeadingZeros = bigIntArray.skipWhile((b) => b == 0).toList();
    result.addAll(bytesWithoutLeadingZeros);
    return result;
  }

  static List<int> _verifyAndRemoveChecksum(List<int> array) {
    final result = array.take(array.length - address_checksum_bytes).toList();
    final checksum = array.skip(result.length).take(address_checksum_bytes).toList();
    final correctCheckSum = _getCheckSum(result);
    if (eq(checksum, correctCheckSum))
      return result;
    else
      return null;
  }


  static List<int> _getCheckSum(List<int> array) {
    List<int> digestBytes = crypto.sha256.convert(crypto.sha256.convert(array).bytes).bytes;
    return digestBytes.take(address_checksum_bytes).toList();
  }

  static String ecPublicKeyToString(ECPublicKey key) => "${key.Q.x},${key.Q.y}";

  static bool checkDartCashAddress(String address) {
    if (!address.startsWith(address_prefix)) {
      return false;
    }
    address = address.substring(address_prefix.length);
    List<int> bytes = _decodeBase58(address);
    final addressBytes = _verifyAndRemoveChecksum(bytes);
    return addressBytes != null;
  }
}

