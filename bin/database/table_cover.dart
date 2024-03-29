import 'package:supabase/supabase.dart';

import '../global.dart';
import 'table_file.dart';

class Cover {
  static const table = 'cover';
  int idThing;
  int idLang;
  String hashFile;

  Cover._(
      {required this.idThing, required this.idLang, required this.hashFile});

  static Future<({DataFile file, Cover cover})> download({
    required int idThing,
    required String lang,
    required bool withText,
    required Uri url,
  }) async {
    try {
      url = Uri.parse(
        url.toString().replaceAll('?type=TEXT&watermark=true', ''),
      );

      if (withText) url = url.replace(queryParameters: {'type': 'TEXT'});
      var fhd = url.path.replaceFirst(RegExp(r'\d{2,4}x\d{2,4}'), '1920x1080');
      url = url.replace(path: fhd);

      var file = await DataFile.download(url: url);

      return (
        file: file,
        cover: Cover._(
          idThing: idThing,
          idLang: withText ? langtags[lang]! : langtags['und']!,
          hashFile: file.hash,
        )
      );
    } catch (e) {
      log.severe('cover␟${e.toString()}');
      throw Exception();
    }
  }

  Future<bool> insert() async {
    try {
      var insert = await supabase.from(table).upsert({
        'id_thing': idThing,
        'id_lang': idLang,
        'hash_file': hashFile
      }).select();
      log.fine('$idThing␟$table␟${insert.first['id']}');
      return true;
    } catch (e) {
      var error = e;
      e is PostgrestException && e.details != null ? error = e.details! : {};
      log.warning('$idThing␟$table␟${error.toString()}');
      return false;
    }
  }

  static Future<void> collect({
    required String lang,
    required int idThing,
    required String idArte,
    required String url,
    required bool text,
  }) async {
    try {
      var filename = '$idArte.webp';
      if (text) filename = '$idArte.$lang.webp';

      final image = await Cover.download(
        lang: lang,
        idThing: idThing,
        url: Uri.parse(url),
        withText: text,
      );

      await image.file.insert();
      await image.cover.insert();
      await image.file.save(covers, filename);
    } catch (e) {
      log.severe('$idThing␟extract_cover␟${e.toString()}');
    }
  }
}
