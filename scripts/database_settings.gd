extends Node

var dictionary_db: Dictionary = {
	'resolution': 0,
	'fps': 60,
	'shadow': 0,
	'antialiasing': 0,
	'master': 50,
	'music': 50,
	'sfx': 50,
	'sense': 20,
	'invert_x': int(false),
	'invert_y': int(false)
}
var db_path := 'res://resources/db/data'
var settings_name := 'settings'
var db: SQLite = SQLite.new()

func load_db() -> void:
	db.path = db_path
	db.open_db()
	
	var rows = db.select_rows(settings_name, '', ['*'])
	if rows.size() < 1:
		db.insert_row(settings_name, dictionary_db)
	else:
		var row = rows[0]
		for col in dictionary_db.keys():
			dictionary_db[col] = row[col]
	
	db.close_db()
	
func update_value(key: String, val) -> void:
	db.open_db()
	db.query_with_bindings('UPDATE '+settings_name+' SET '+key+'=?',[val])
	db.close_db()
