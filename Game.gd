extends Node


enum CheckLetter {
	NOT_IN_WORD,
	WRONG_PLACE,
	CORRECT,
}


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
				return
			word_attempt = word_attempt.to_lower()
			var attempt_result := check_word(word_attempt, word_to_guess)
			if attempt_result.empty():
				return
			for i in range(5):
				update_color_panel(attempt_result[i], current_attempt, i + 1)
			if word_attempt == word_to_guess:
				$Words/Message.text = "You Win!"
				set_process_input(false)
			current_attempt += 1
			current_letter = 1
			word_attempt = ""


func check_word(word: String, correct_word: String) -> Array:
	var result = []

	if not (word in WordList.WORDS):
		return result

	for i in range(5):
		if not (word[i] in correct_word):
			result.append(CheckLetter.NOT_IN_WORD)
		elif word[i] == correct_word[i]:
			result.append(CheckLetter.CORRECT)
		else:
			result.append(CheckLetter.WRONG_PLACE)

	return result


func update_letter_panel(letter: String, attempt_number: int, letter_number: int) -> void:
	word_rows[attempt_number - 1].get_node("Letter" + str(letter_number) + "/Letter").text = letter


func update_color_panel(check_letter: int, attempt_number: int, letter_number: int) -> void:
	match check_letter:
		CheckLetter.NOT_IN_WORD:
			word_rows[attempt_number - 1].get_node("Letter" + str(letter_number)).color = Color.black
		CheckLetter.WRONG_PLACE:
			word_rows[attempt_number - 1].get_node("Letter" + str(letter_number)).color = Color.yellow
		CheckLetter.CORRECT:
			word_rows[attempt_number - 1].get_node("Letter" + str(letter_number)).color = Color.yellowgreen
