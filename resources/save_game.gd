class_name SaveGame
extends Resource

const SAVE_PATH = "user://saves/data/data."

export var player_data: Resource = PlayerData.new()

func save_data():
	if not ResourceLoader.exists(get_save_path()):
		Directory.new().make_dir("user://saves/data")
	ResourceSaver.save(get_save_path(), self)

static func save_exists():
	return ResourceLoader.exists(get_save_path())

static func load_data():
	var save_path := get_save_path()
	if ResourceLoader.has_cached(save_path):
		# Once the resource caching bug is fixed, you will only need this line of code to load the save game.
		return ResourceLoader.load(save_path, "", true)
	
	# /!\ Workaround for bug https://github.com/godotengine/godot/issues/59686
	# Without that, sub-resources will not reload from the saved data.
	# We copy the SaveGame resource's data to a temporary file, load that file
	# as a resource, and make it take over the save game.

	# We first load the save game resource's content as a byte array and store it.
	var file := File.new()
	if file.open(save_path, File.READ) != OK:
		printerr("Couldn't read file " + save_path)
		return null

	var data := file.get_buffer(file.get_len())
	file.close()

	# Then, we generate a random file path that's not in Godot's cache.
	var tmp_file_path := make_random_path()
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = make_random_path()

	# We write a copy of the save game to that temporary file path.
	if file.open(tmp_file_path, File.WRITE) != OK:
		printerr("Couldn't write file " + tmp_file_path)
		return null

	file.store_buffer(data)
	file.close()

	# We load the temporary file as a resource.
	var save = ResourceLoader.load(tmp_file_path, "", true)
	# And make it take over the save path for the next time the player
	# saves.
	save.take_over_path(save_path)
	
	# We delete the temporary file.
	var directory := Directory.new()
	directory.remove(tmp_file_path)
	
	
	return save

static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"

static func get_save_path() -> String:
	return SAVE_PATH + "tres" if OS.is_debug_build() else "res"

func get_data() -> PlayerData:
	return player_data as PlayerData
