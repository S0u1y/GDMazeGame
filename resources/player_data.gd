class_name PlayerData
extends Resource

export var coins: int = 0
export var cosmetics: Dictionary = {}
export (String, "Robert", "Minnie") var p1_character = "Robert"
export (String, "Robert", "Minnie") var p2_character = "Minnie"
export var p1_equips: Resource = PlayerEquips.new()
export var p2_equips: Resource = PlayerEquips.new()

func _init():
	load_new()

#Load new cosmetics into dictionary and remove any cosmetics that were deleted
func load_new():
	var cosmetics_files = []
	var cosmetic_names = []
	var directory = Directory.new()
	if directory.open("res://resources/accessories/") == OK:
		directory.list_dir_begin(true, true)
		var file_name = directory.get_next()
		while file_name != "":
			if file_name.begins_with("__"):
				file_name = directory.get_next()
				continue
			
			if file_name.ends_with("res"):
				var cosmetic_name = file_name.split(".")[0]
				cosmetics_files.append(file_name)
				cosmetic_names.append(cosmetic_name)
				if not cosmetic_name in cosmetics:
					cosmetics[cosmetic_name] = load("res://resources/accessories/".plus_file(file_name)).duplicate(true)
			
			file_name = directory.get_next()
	
	for cosmetic_name in cosmetics:
		if not cosmetic_name in cosmetic_names:
			cosmetics.erase(cosmetic_name)
	
func get_property_by_player_idx(idx:int, property_name:String):
	return self["p"+String(idx)+"_"+property_name]

func get_data_by_player_idx(idx:int):
	return {
		"character": get_property_by_player_idx(idx, "character"),
		"equips": get_property_by_player_idx(idx, "equips")
	}
