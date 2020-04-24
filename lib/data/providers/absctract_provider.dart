abstract class AbstractProvider {
  Future<List<Map<String, dynamic>>> getAll();
  Future<Map<String, dynamic>> getOne(String id);
  Future<bool> create(Map<String, dynamic> map);
  Future<bool> update(Map<String, dynamic> map);
  Future<bool> delete(String id);
}
