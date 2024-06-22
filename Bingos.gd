extends Node

var words = []
var bingo : String
var anagram : String

func _ready():
	load_words("res://data/bingos.txt")
	select_word()
	

func load_words(file_path: String):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		while not file.eof_reached():
			var word = file.get_line()
			words.append(word)
		file.close()
		print("Words loaded:", words)
	else:
		print("Failed to load file:", file_path)

func select_word():
	bingo = words.pick_random()
	generate_anagram(bingo)
	print("Bingo word:", bingo)
	print("Anagram:", anagram)
	$Anagram.text = anagram

func generate_anagram(bingo :String):
	var chars = bingo.split("")
	chars.sort()
	anagram = "".join(chars)

func _on_line_edit_text_submitted(new_text: String) -> void:
	if new_text == bingo:
		$LineEdit.clear()
		select_word()
	else:
		$LineEdit.clear()
		print("incorrect")
