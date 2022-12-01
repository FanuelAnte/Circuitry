extends Control


func _ready():
	pass

func _on_StartBtn_pressed():
	get_tree().change_scene("res://Scenes/MainGame.tscn")

func _on_ExitBtn_pressed():
	get_tree().quit()
