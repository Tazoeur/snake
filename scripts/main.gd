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
var regen_food = true
var food_position: Vector2

var move_direction: Vector2
var can_move: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_snake()
	move_food()
	$Food.visible = true
	move_direction = up
	can_move = true


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
	move_snake()
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score)

func game_start():
	$MoveTimer.start()
	
func move_snake():
	if not can_move:
		return
	var has_moved = false
	if Input.is_action_just_pressed("move_down") and move_direction != up:
		move_direction = down
		can_move = false
		has_moved = true
	elif Input.is_action_just_pressed("move_up") and move_direction != down:
		move_direction = up
		can_move = false
		has_moved = true
	elif Input.is_action_just_pressed("move_left") and move_direction != right:
		move_direction = left
		can_move = false
		has_moved = true
	elif Input.is_action_just_pressed("move_right") and move_direction != left:
		move_direction = right
		can_move = false
		has_moved = true
	if not game_started and has_moved:
		game_start()

func _on_move_timer_timeout() -> void:
	old_data = [] + snake_data
	snake_data[0] += move_direction
	snake_data[0]
	for i in range(len(snake_data)):
		if i > 0:
			snake_data[i] = old_data[i-1]
		snake[i].position = (snake_data[i] * cell_size) + Vector2(0, cell_size)

	check_out_of_bounds()
	check_self_eaten()
	check_food_eaten()
	can_move = true

func check_out_of_bounds():
	if snake[0].position[0] >= cells * cell_size or snake[0].position[0] <= 0:
		game_over()
	if snake[0].position[1] >= cells * cell_size or snake[0].position[1] <= 0:
		game_over()

func game_over():
	print("game over!!")
	
	
func check_self_eaten():
	# Impossible de se "self-eaten" avant d'avoir 5 cellules
	if len(snake_data) < 4:
		return
		
	var head = snake_data[0]
	for i in range(4,len(snake_data) ):
		if snake_data[i] == head:
			game_over()
	
func check_food_eaten():
	var head = snake_data[0]
	if head == food_position:
		score += 1
		add_segment(old_data[-2])
		move_food()

func move_food():
	print("call to move_food")
	while regen_food:
		regen_food = false
		food_position = Vector2(randi_range(0, cells - 1), randi_range(0, cells - 1))
		print(food_position)
		for cell_position in snake_data:
			if food_position == cell_position:
				regen_food = true
	$Food.position = (food_position * cell_size) + Vector2(0, cell_size)
	regen_food = true
