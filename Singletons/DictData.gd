extends Node


var dictData = []
var lexDict_file_path = "res://Data/entries_with_lexdef_only.json"

func _ready():
	dictData = load_json(lexDict_file_path)
	print("DictData loaded:", dictData.size())

func load_json(filePath : String):
	if FileAccess.file_exists(filePath):
		
		var dictFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedDict = JSON.parse_string(dictFile.get_as_text())
		
		if parsedDict is Array:
			return parsedDict
		elif parsedDict is Dictionary:
			return parsedDict
		else:
			print("Error reading lexDict JSON")
		
	else: 
		print("dictFile doesn't exist")
		



	
