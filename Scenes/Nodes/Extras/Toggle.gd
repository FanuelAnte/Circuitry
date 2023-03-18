extends CheckButton

signal input_toggled(value, index)

func _ready():
	pass

func _on_Toggle_toggled(button_pressed):
	emit_signal("input_toggled", button_pressed, get_index())
