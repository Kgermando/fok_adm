import 'dart:async';
import 'dart:io';
import 'package:dospace/dospace.dart' as dospace;

// const bucketName = '';

class FileUploader {
  static dospace.Spaces spaces = dospace.Spaces(
    region: "ams3",
    accessKey: "5Z7HJJQSTHU3HNVX5PGI",
    secretKey: "ZrKgGymuT9O5M/40sIUg6Lvgjw09Fo+C0a8p7JFX9dc",
  );

  static Future<dynamic> uploadFile(
      String fileName, File file, String type) async {
    dospace.Bucket bucket = spaces.bucket("clinic");

    try {
      String? etag = await bucket.uploadFile(
          fileName, file, type, dospace.Permissions.public);
      return etag;
    } catch (e) {
      return e;
    }
  }
}