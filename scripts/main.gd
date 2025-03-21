extends Node

@export var snake_scene: PackedScene

var score: int
var game_started: bool = false

var cells: int = 20
var cell_size: int = 50

var old_data: Array
var snake_data: Array
var snake: Array
var start_position = Vector2(9,9)
var up = Vector2(0,-1)
var down = Vector2(0,1)
var left = Vector2(-1,0)
var right = Vector2(1,0)

var move_direction: Vector2
var can_move: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_snake()

func generate_snake():
	old_data.clear()
	snake_data.clear()
	snake.clear()
	for i in range(3):
		add_segment(start_position + Vector2(0,i))
		
func add_segment(pos: Vector2):
	snake_data.append(pos)
	var snake_segment = snake_scene.instantiate()
	snake_segment.position = pos * cell_size
	add_child(snake_segment)
	snake.append(snake_segment)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
