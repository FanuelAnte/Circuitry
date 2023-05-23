extends Node

var connections = []

var line_colors = {"active" : "7dd4cc", "inactive" : "3c5a5e"}

var problem_list = [
	{"id": 0,
	"name": "AND",
	"description": "Basic.",
	"validation_table": [["11","10","01","00"],["1","0","0","0"]]},
	{"id": 1,
	"name": "NAND",
	"description": "Combine.",
	"validation_table": [["11","10","01","00"],["0","1","1","1"]]},
	{"id": 2,
	"name": "OR",
	"description": "Combine some more.",
	"validation_table": [["11","10","01","00"],["1","1","1","0"]]},
	{"id": 3,
	"name": "NOR",
	"description": "Not!!!",
	"validation_table": [["11","10","01","00"],["0","0","0","1"]]},
	{"id": 4,
	"name": "XOR",
	"description": "Exclusive.",
	"validation_table": [["11","10","01","00"],["0","1","1","0"]]},
	{"id": 5,
	"name": "XNOR",
	"description": "Not Exclusive.",
	"validation_table": [["11","10","01","00"],["1","0","0","1"]]},
]

var current_problem = {}

func _ready():
	pass
