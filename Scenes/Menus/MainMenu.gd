extends Control


func _ready():
	pass

func _on_ExitBtn_pressed():
	get_tree().quit()

func _on_EditBtn_pressed():
	get_tree().change_scene("res://Scenes/MainGame.tscn")
