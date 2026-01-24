import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Service for cryptographic operations related to PIN security.
/// Uses PBKDF2 with SHA-256 for secure PIN hashing.
class CryptoService {
  final int iterations;
  final int saltLength;
  final int hashLength;

  CryptoService({
    this.iterations = 10000,
    this.saltLength = 32,
    this.hashLength = 32,
  });

  /// Generate a cryptographically secure random salt
  String generateSalt() {
    final random = Random.secure();
    final saltBytes =
        List<int>.generate(saltLength, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  /// Hash PIN using PBKDF2-SHA256
  /// Returns base64-encoded hash
  String hashPin(String pin, String salt) {
    final saltBytes = base64Decode(salt);
    final pinBytes = utf8.encode(pin);

    // PBKDF2 implementation using HMAC-SHA256
    final hash = _pbkdf2(pinBytes, saltBytes, iterations, hashLength);
    return base64Encode(hash);
  }

  /// Verify PIN by comparing hashes
  bool verifyPin(String pin, String salt, String storedHash) {
    final computedHash = hashPin(pin, salt);
    return _constantTimeCompare(computedHash, storedHash);
  }

  /// PBKDF2 key derivation function
  Uint8List _pbkdf2(
      List<int> password, List<int> salt, int iterations, int keyLength) {
    final hmac = Hmac(sha256, password);
    final numBlocks = (keyLength / 32).ceil();
    final result = <int>[];

    for (var blockNum = 1; blockNum <= numBlocks; blockNum++) {
      final block = _pbkdf2Block(hmac, salt, iterations, blockNum);
      result.addAll(block);
    }

    return Uint8List.fromList(result.take(keyLength).toList());
  }

  List<int> _pbkdf2Block(
      Hmac hmac, List<int> salt, int iterations, int blockNum) {
    // First iteration: HMAC(password, salt || INT(blockNum))
    final blockBytes = [
      (blockNum >> 24) & 0xff,
      (blockNum >> 16) & 0xff,
      (blockNum >> 8) & 0xff,
      blockNum & 0xff,
    ];

    var u = hmac.convert([...salt, ...blockBytes]).bytes;
    var result = List<int>.from(u);

    // Subsequent iterations
    for (var i = 1; i < iterations; i++) {
      u = hmac.convert(u).bytes;
      for (var j = 0; j < result.length; j++) {
        result[j] ^= u[j];
      }
    }

    return result;
  }

  /// Constant-time string comparison to prevent timing attacks
  bool _constantTimeCompare(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }
}
