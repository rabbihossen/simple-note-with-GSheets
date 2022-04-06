import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  
{
  "type": "service_account",
  "project_id": "flutternote-346220",
  "private_key_id": "00a73280d02992707695cba4aa60e1ad2199b4c4",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC0Ll8/xjo090IZ\nw7yQKlpf+AX49MEiE7W/9cvbc1FNUQQTWh6RS87Mfvu1JqZ+9/srbdR6jhZ9Ttns\nagK3np2QE1fvJiJawh6zOo9a0/GS1/G3x1HLMXjDlaiZX1fXAzhIh05z2vbyuMpN\n2y4nq3XNRZgEP0RxTulho+8qI6waa+jHR8GrKop/GplYbX1ERLcSbXB1y5U/Pfng\n8SAiD6Qahu3JeKXXSwKqXAchmrJjgE+lHL4S6LPB8bZY+n+zda3hnYFtL4b9Iajm\nBhYjVfCITWSQy93FuTdKIiZ00GzGhCpwMy5FtE09bzySuPJnDYuuuJlxcVXCKzMx\n7Ea0CuWNAgMBAAECggEAHvesW7HmXaWUeQik7zM0SrO+VQo96m0wSuCEK8CvW8Y9\nmNTflZHNpmR5vun4ajCVPOLYxsKGd312o3UZ5/StOG62qY3okCg2bg/1xQLRzW7r\nZq5tbqqfSqA9dLTIDFaLlR2aPHvI/zEG5igyT9OegMwCA1LbYM0S+/rYt2mfof+Z\njwF+bXhcRltq3QmTUVw0MKkEHxVrZbRn1MVOHZbPUuXoPfemsdLcbSMi1OO6yGkl\nGgosNzOI2Awd3O8q+IHb6hLEIyD+MhPSE4nbhM8a/4dkcsEkPiGYTtBg0ptyZt3T\n+fOR0QVOVDJ+Zk/XL4T0NEeEfJXim9pzim1VCuRCIQKBgQDb6LQLsSkKGuSl7058\n2v6yrIxEzFsZ7lZbOdM7hsNV4/UQn3h4tBSwJZgM8XvdU4TVuI5fD+a8cPFzoWCp\nNbwkGKL36nXEk8VmeUUpPnlYgQg9dug+Q+vIaVf9hpXB27I0DA16NmdCGBHiAm++\nHzl/g1rQobtxkJhYjnpgOYNmbQKBgQDRwIkNk3CygcZ0ZzUqG1bnHFJ2TaWKRhXL\nzCpmyzLUZKr2rFRyfe89wEs5ruCmnXKEtbmNxXX6nxbAdRwwgwkasXfmFsV6xaKB\n7e8ipDLGux4VjsDa9l8KPdayY3Vm1bNqCnN4ws1Z1z9ld0wHOGMl3RBpu6luoPj0\nj++epHSHoQKBgEnAGhnNuWC9Mi+AOUdgPoj3mzc7fdYNe4Kuuuu8v2ffwoFnqgR5\nCHMmuH6mwg6xAtyWP5EcCRrrmd5Yoc09yzIj3Qvd4s8ha9N5GjvByvpmk7fhV/QB\n3WJiCfNpnnHcV0BjRmXVNv4QinbMsGMHn8Xm7J8Jjo6AmscgSWRaBXplAoGAOhEi\nH/cESPayWQFFb424Bi0KCyQ9wsTaPdwclO6F+NSRm85jZnrEo4S7jpGCMb3+uQyR\n/NSAb8xhARCqqCduesxMlA8TxoQ2E+Apxp5MTEX68x7c9wEjmHM8H5B3LOvWSnHw\nO6s6LDfxngZjrtAGarIDXDIOmsjHgvTh8jo25GECgYEAl7yUVuEBqobCyiJdHZP/\nNcTBZ/4BgbIcN2mMvL3X6ddcyec/RMx6lgSY+Vgh8Pd0RAVBTWVgzQqrK3JvPTEE\nPDglml4/maFBcWz4WiGJnN5ML1bbXxLN+Ekh6WiCCASZlaZ0rgfGOJNf52bXBocO\n+CIYoZrCRVPSUDDhXpQIZbc=\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-note@flutternote-346220.iam.gserviceaccount.com",
  "client_id": "101989070136574578499",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-note%40flutternote-346220.iam.gserviceaccount.com"
}


  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1wNpTU5w1ode53a0a-lFgMJBvuIFMbnybjDgFLzrDwmk';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfNotes = 0;
  static List<String> currentNotes = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Note');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while (
        (await _worksheet!.values.value(column: 1, row: numberOfNotes + 1)) !=
            '') {
      numberOfNotes++;
    }
    // now we know how many notes to load, now let's load them!
    loadNotes();
  }

  // insert a new note
  static Future insert(String note) async {
    if (_worksheet == null) return;
    numberOfNotes++;
    currentNotes.add(note);
    await _worksheet!.values.appendRow([note]);
  }

  // load existing notes from the spreadsheet
  static Future loadNotes() async {
    if (_worksheet == null) return;

    for (int i = 0; i < numberOfNotes; i++) {
      final String newNote =
          await _worksheet!.values.value(column: 1, row: i + 1);
      if (currentNotes.length < numberOfNotes) {
        currentNotes.add(newNote);
      }
    }
    // this will stop the circular loading indicator
    loading = false;
  }
}
