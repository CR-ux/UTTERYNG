extends Node2D


@onready var artScape = $ArtScape
@onready var letterScene = preload("res://LetterScene.tscn")
@onready var dict_copy = DictData.dictData.duplicate()


var scapes = []
var collected_letters: Array[String] = []
var currentAltitude = 0



func _ready() -> void:
	load_artScapes("res://Assets")
	scapes.shuffle()
	artScape.texture = scapes[0]
	spawnLetterFall(altitudeToMaxLen(currentAltitude))

	
func load_artScapes(path: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var scapeName = dir.get_next()
		while scapeName != "":
			if not dir.current_is_dir() and scapeName.ends_with(".png"):
				var tex = load(path + "/" + scapeName)
				scapes.append(tex)
			scapeName = dir.get_next()
		dir.list_dir_end()
		

func spawnLetterFall(maxLen: int):
	var letter = letterScene.instantiate()
	letter.letter = LexUtils.randomLetter()
	letter.position = Vector2(randi() % 3500, -50)
	letter.connect("letter_caught", Callable(self, "_on_letter_caught").bind(maxLen))
	add_child(letter)
	

func _on_letter_caught(letter: String, maxLen: int):
	print("Caught letter: ", letter)
	collected_letters.append(letter)
	check_for_word(maxLen)
	await get_tree().create_timer(0.2).timeout
	spawnLetterFall(altitudeToMaxLen(currentAltitude))
	

func check_for_word(maxLen: int):
	if collected_letters.is_empty():
		return

	var seen = {}

	for i in range(1, min(collected_letters.size(), maxLen) + 1):
		var perms = LexUtils._get_permutations(collected_letters, i)
		for word in perms:
			var word_str = "".join(word).to_lower()
			if seen.has(word_str):
				continue
			seen[word_str] = true
			
			if LexUtils.lexicon.has(word_str):
				var entry = LexUtils.lexicon[word_str]
				print("MATCHED:", word_str)
				print("DEF:", entry["body"])
				
				LexUtils.lexicon.erase(word_str)
				_remove_letters(word_str)
				check_for_word(maxLen)
				return
				
			for entry in dict_copy:
				if entry.has("lexeme") and entry["lexeme"].to_lower() == word_str:
					print("FOUND 'gate' IN DICT!", entry)


func _remove_letters(word: String) -> void:
	for letter_char in word:
		var index = collected_letters.find(letter_char)
		if index != -1:
			collected_letters.remove_at(index)


func altitudeToMaxLen(altitude: int) -> int:
	var table = [3, 6, 9, 12]
	return table[clamp(altitude, 0, table.size() -1)]
	

func on_zone_entered(body: Node, altitude: int) -> void:
	if body.name == "Aria":
		currentAltitude = altitude
		print("Altitude changed to:", altitude)


#signals for altitudes

func _on_alt_3_body_entered(body: Node2D) -> void:
	on_zone_entered(body, 0)
	
	
func _on_alt_6_body_entered(body: Node2D) -> void:
	on_zone_entered(body, 1)

func _on_alt_9_body_entered(body: Node2D) -> void:
	on_zone_entered(body, 2)
	

func _on_alt_12_body_entered(body: Node2D) -> void:
	on_zone_entered(body, 3)
