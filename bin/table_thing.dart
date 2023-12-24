import 'global.dart';

class Thing {
  static const table = 'thing';

  static Future<List<Map<String, dynamic>>> all() async {
    var select = await supabase.from(table).select();
    log.info('FETCH␟${select.length}␟$table');
    return select;
  }

  static Future<Map<String, dynamic>> get(String arteId) async {
    final thing = await supabase.from(table).select().eq('arte', arteId);
    log.info('${thing.first['id']}␟$table␟$arteId');
    return thing.first;
  }

  static Future<int> getIdOrInsert(int typeId, String arteId) async {
    try {
      final thing = await supabase.from(table).select().eq('arte', arteId);
      if (thing.isNotEmpty) {
        log.info('$arteId␟$table␟${thing.first['id']}');
        return thing.first['id'];
      } else {
        final newThing = await supabase
            .from('thing')
            .insert({'id_type': typeId, 'arte': arteId}).select();
        log.fine('${newThing.first['id']}␟$table␟$arteId');
        return newThing.first['id'];
      }
    } catch (e) {
      log.warning('FETCH␟$table␟$arteId␟${e.toString()}');
      throw Exception();
    }
  }
}
