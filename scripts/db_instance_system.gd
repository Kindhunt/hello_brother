extends Node

var db: SQLite = null
# var db_name: String = "res://data/hidenseek_db"

func reset_db():
	pass

func insert_table_row(table: String, row: Dictionary):
	db.open_db()
	db.insert_row(table, row)
	db.close_db()

func update_table_row(table: String, condition: String, row: Dictionary):
	db.open_db()
	db.update_rows(table, condition, row)
	db.close_db()

func delete_table_row(table: String, condition: String):
	db.open_db()
	db.delete_rows(table, condition)
	db.close_db()

func select_table_rows(table: String, condition: String, columns: Array):
	db.open_db()
	var rows = db.select_rows(table, condition, columns)
	db.close_db()
	return rows
	
	# on click save on slot # write save to slot
	# on click delete on slot # delete slot
	# on click write on slot # rewrite data to actual one
	
	# also, i need use sqlite database as data storage for game language locales, 
	# english and russian
