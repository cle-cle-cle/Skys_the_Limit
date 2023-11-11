tool
class_name Enemy extends Pawn

onready var hp_label = $HPLabel
onready var atk_label = $ATKLabel
onready var def_label = $DEFLabel

onready var sprite = $Sprite
onready var area_2d = $Area2D



var health = 1
var max_health = 1
var attack = 1
var defense = 1


# Declare member variables here. Examples:
enum ENEMY_TYPES{ GREEN, BLUE, PINK, BOSS }
export(ENEMY_TYPES) var enemy_type = ENEMY_TYPES.GREEN setget set_enemy_type


func set_enemy_type(type):
	enemy_type = type


# Called when the node enters the scene tree for the first time.
func _ready():
	if enemy_type == ENEMY_TYPES.BOSS:
		hp_label.rect_position += Vector2(0, -40)
		atk_label.rect_position += Vector2(0, 30)
		def_label.rect_position += Vector2(0, 30)
	initialize_sprite()
	initialize_stats()
	update_labels()
	
	

func _process(delta):
		update_labels()


func initialize_sprite():
	match enemy_type:
		ENEMY_TYPES.GREEN:
			sprite.texture = preload("res://game/assets/slime_green.png")
		ENEMY_TYPES.BLUE:
			sprite.texture = preload("res://game/assets/slime_blue.png")
		ENEMY_TYPES.PINK:
			sprite.texture = preload("res://game/assets/slime_pink.png")
		ENEMY_TYPES.BOSS:
			sprite.texture = preload("res://game/assets/ladyangel.png")


func initialize_stats():
	match enemy_type:
		ENEMY_TYPES.GREEN:
			health = 10
			max_health = 10
			attack = 20
			defense = 10
		ENEMY_TYPES.BLUE:
			health = 20
			max_health = 20
			attack = 25
			defense = 15
		ENEMY_TYPES.BOSS:
			health = 999
			max_health = 999
			attack = 300
			defense = 1


func update_labels():
	$HPLabel.text = String(health) + "/" + String(max_health)
	$ATKLabel.text = String(attack)
	$DEFLabel.text = String(defense)




func _on_Area2D_mouse_entered():
	emit_signal("mouse_entered_pawn")


func _on_Area2D_mouse_exited():
	emit_signal("mouse_left_pawn")
