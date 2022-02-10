extends Node


var word_to_guess := ""
var word_attempt := ""

var current_attempt := 1
var current_letter := 1

onready var word_rows := [
	$Words/WordRows/WordRow1,
	$Words/WordRows/WordRow2,
	$Words/WordRows/WordRow3,
	$Words/WordRows/WordRow4,
	$Words/WordRows/WordRow5,
	$Words/WordRows/WordRow6,
]


func _ready():
	word_to_guess = WordList.get_todays_word()


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.unicode != 0:
			var letter := char(event.unicode).to_upper()
			if current_letter <= 5:
				word_attempt += letter
				update_letter_panel(letter, current_attempt, current_letter)
				current_letter += 1
		elif event.scancode == KEY_BACKSPACE:
			if current_letter > 1:
				current_letter -= 1
			word_attempt.erase(current_letter - 1, 1)
			update_letter_panel("", current_attempt, current_letter)
		elif event.scancode == KEY_ENTER:
			if word_attempt.length() < 5:
				$Words/Message.text = "Type 5 letters"
				return
			word_attempt = word_attempt.to_lower()
			var attempt_result := check_word(word_attempt, word_to_guess)
			if attempt_result.empty():
				$Words/Message.text = "Not in dictionary"
				return
			for i in range(5):
				update_color_panel(attempt_result[i], current_attempt, i + 1)
				$Keyboard.change_letter_key_color(word_attempt[i], attempt_result[i])
			if word_attempt == word_to_guess:
				$Words/Message.text = "You Win!"
				set_process_input(false)
				return
			current_attempt += 1
			if current_attempt > 6:
				$Words/Message.text = "The word was: " + word_to_guess
				set_process_input(false)
				return
			current_letter = 1
			word_attempt = ""
			$Words/Message.text = "Godot Wordle"


func check_word(word: String, correct_word: String) -> Array:
	var result = []

	if not (word in WordList.DICTIONARY):
		return result

	for i in range(5):
		if not (word[i] in correct_word):
			result.append(Globals.CheckLetter.NOT_IN_WORD)
		elif word[i] == correct_word[i]:
			result.append(Globals.CheckLetter.CORRECT)
		else:
			result.append(Globals.CheckLetter.WRONG_PLACE)

	return result


func update_letter_panel(letter: String, attempt_number: int, letter_number: int) -> void:
	word_rows[attempt_number - 1].get_node("Letter" + str(letter_number) + "/Letter").text = letter


func update_color_panel(check_letter: int, attempt_number: int, letter_number: int) -> void:
	var panel: ColorRect = word_rows[attempt_number - 1].get_node("Letter" + str(letter_number))
	match check_letter:
		Globals.CheckLetter.NOT_IN_WORD:
			panel.color = Color.black
		Globals.CheckLetter.WRONG_PLACE:
			panel.color = Color.yellow
		Globals.CheckLetter.CORRECT:
			panel.color = Color.yellowgreen
