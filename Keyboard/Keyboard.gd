class_name Keyboard
extends VBoxContainer


func _ready() -> void:
	for node in get_tree().get_nodes_in_group("LetterKeys"):
		var key := node as Button
		assert(key)
		key.pressed.connect(_send_letter_key_input_event.bind(_char_to_ascii_int(key.text.to_lower())))


func change_letter_key_color(letter: String, check_letter: int) -> void:
	for node in get_tree().get_nodes_in_group("LetterKeys"):
		var key := node as Button
		assert(key)
		if letter == key.text.to_lower():
			match check_letter:
				Globals.CheckLetter.NOT_CHECKED:
					key.self_modulate = Color.WHITE
				Globals.CheckLetter.NOT_IN_WORD:
					if key.self_modulate != Color.YELLOW and key.self_modulate != Color.YELLOW_GREEN:
						key.self_modulate = Color.INDIAN_RED
				Globals.CheckLetter.WRONG_PLACE:
					if key.self_modulate != Color.YELLOW_GREEN:
						key.self_modulate = Color.YELLOW
				Globals.CheckLetter.CORRECT:
					key.self_modulate = Color.YELLOW_GREEN


func _char_to_ascii_int(letter: String) -> int:
	var buffer := StreamPeerBuffer.new()
	buffer.data_array = letter.to_ascii_buffer()
	return buffer.get_8()


func _send_letter_key_input_event(unicode: int) -> void:
	var event := InputEventKey.new()
	event.pressed = true
	event.unicode = unicode
	Input.parse_input_event(event)


func _on_BackSpace_pressed() -> void:
	var event := InputEventKey.new()
	event.pressed = true
	event.keycode = KEY_BACKSPACE
	Input.parse_input_event(event)


func _on_Enter_pressed() -> void:
	var event := InputEventKey.new()
	event.pressed = true
	event.keycode = KEY_ENTER
	Input.parse_input_event(event)
