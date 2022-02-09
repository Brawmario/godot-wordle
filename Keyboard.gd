extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in get_tree().get_nodes_in_group("LetterKeys"):
		key.connect("pressed", self, "_send_letter_key_input_event", [_char_to_ascii_int(key.text.to_lower())])


func _char_to_ascii_int(key: String) -> int:
	var spb := StreamPeerBuffer.new()
	spb.data_array = key.to_ascii()
	return spb.get_8()


func _send_letter_key_input_event(unicode: int) -> void:
	var event := InputEventKey.new()
	event.pressed = true
	event.unicode = unicode
	Input.parse_input_event(event)


func _on_BackSpace_pressed() -> void:
	var event := InputEventKey.new()
	event.pressed = true
	event.scancode = KEY_BACKSPACE
	Input.parse_input_event(event)


func _on_Enter_pressed() -> void:
	var event := InputEventKey.new()
	event.pressed = true
	event.scancode = KEY_ENTER
	Input.parse_input_event(event)
