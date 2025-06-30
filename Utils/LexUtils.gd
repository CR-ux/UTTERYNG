extends Node

var lexicon = {}
var alphaStash: Array[String] = []


func _ready():
	#Stash entire ascii casings
	for i in range(26):
		alphaStash.append(String.chr(65 + i))
		alphaStash.append(String.chr(97 + i))
	print("alphaStash: ", alphaStash)
	

func randomLetter() -> String:
	return alphaStash[randi() % alphaStash.size()]


func _get_permutations(arr: Array, length: int) -> Array:
	var results = []
	_permute(arr, [], length, results)
	return results


func _permute(available: Array, current: Array, length: int, results: Array):
	if current.size() == length:
		results.append(current.duplicate())
		return
	for i in range(available.size()):
		var next_available = available.duplicate()
		var next = next_available.pop_at(i)
		_permute(next_available, current + [next], length, results)


func build_lexicon():
	for entry in DictData.dictData:
		if entry.has("lexeme"):
			var word = entry["lexeme"].to_lower()
			lexicon[word] = entry
	print("Lexicon built with keys:", lexicon.keys())
