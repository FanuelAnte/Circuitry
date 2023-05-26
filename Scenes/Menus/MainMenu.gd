extends Control

onready var problem_template_scene = preload("res://Scenes/Menus/ProblemTemplate.tscn")
onready var problem_list = $ScrollContainer/VBoxContainer

func _ready():
	for i in Globals.problem_list:
		var prob = problem_template_scene.instance()
		problem_list.add_child(prob)
		prob.init_problem(i["id"], i["name"], i["description"], Globals.problem_progress[i["id"]])
		
func _on_ExitBtn_pressed():
	get_tree().quit()

func _on_EditBtn_pressed():
	get_tree().change_scene("res://Scenes/MainGame.tscn")
