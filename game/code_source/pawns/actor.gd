extends "pawn.gd"

signal step_consumed
signal landed_on_new_pos

onready var Grid = get_parent()

onready var hp_label = $HPLabel
onready var atk_label = $ATKLabel
onready var def_label = $DEFLabel

onready var input_cooldown = $InputCooldown


var is_input_in_cd = false


func _ready():
	update_look_direction(Vector2(1, 0))
	
	# Update Player Stats Labels
	update_labels()
	

func _process(_delta):
	update_labels()
#
#
#func _unhandled_input(event):
	# If player holds down move button, actor will slip

#	if is_input_in_cd :
#		return
#
#	is_input_in_cd = true
#	input_cooldown.start()
	
	# Player Movement
	var movement_dir := Vector2.ZERO
	
	if Input.is_action_just_pressed("game_up"):
		movement_dir.y = -1
	elif Input.is_action_just_pressed("game_down"):
		movement_dir.y = 1
	elif Input.is_action_just_pressed("game_left"):
		movement_dir.x = -1
	elif Input.is_action_just_pressed("game_right"):
		movement_dir.x = 1
	
#	if event is InputEventKey:
#		if event.pressed and ( event.scancode == KEY_UP or event.scancode == KEY_W ):
#			movement_dir.y = -1
#		elif event.pressed and ( event.scancode == KEY_DOWN or event.scancode == KEY_S ):
#			movement_dir.y = 1
#		elif event.pressed and ( event.scancode == KEY_LEFT or event.scancode == KEY_A ):
#			movement_dir.x = -1
#		elif event.pressed and ( event.scancode == KEY_RIGHT or event.scancode == KEY_D ):
#			movement_dir.x = 1
	
	if not movement_dir:
		return
	update_look_direction(movement_dir)

	var target_position = Grid.request_move(self, movement_dir)
	if target_position:
		move_to(target_position)
		emit_signal("step_consumed")
	else:
		bump()


func update_look_direction(direction):
	if direction.x == 1:
		$Sprite.flip_h = false
	if direction.x == -1:
		$Sprite.flip_h = true


func move_to(target_position):
	set_process(false)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("walk")

	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
	# var move_direction = (target_position - position).normalized()
		
	$Tween.interpolate_property(
		self,"position",
		position,target_position,
		$AnimationPlayer.current_animation_length,
		Tween.TRANS_LINEAR, Tween.EASE_IN)

	$Tween.start()

	# Stop the function execution until the animation finished
	yield($AnimationPlayer, "animation_finished")
	
	emit_signal("landed_on_new_pos")
	
	set_process(true)


func bump():
	set_process(false)
	$AnimationPlayer.play("bump")
	yield($AnimationPlayer, "animation_finished")
	set_process(true)


func update_labels():
	hp_label.text = String(PlayerStats.health) + "/" + String(PlayerStats.max_health)
	atk_label.text = String(PlayerStats.attack)
	def_label.text = String(PlayerStats.defense)


func _on_InputCooldown_timeout():
	is_input_in_cd = false
