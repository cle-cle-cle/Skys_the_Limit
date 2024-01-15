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
enum ENEMY_TYPES{WEAK, GREEN, BLUE, PINK, ANGEL, BOSS, BOSS_PHT, Bonus_1, 
					Green_1, Blue_1, Pink_1, Green_2, Blue_2, Pink_2, Green_3, Blue_3, Pink_3, Bonus_2}
export(ENEMY_TYPES) var enemy_type = ENEMY_TYPES.GREEN setget set_enemy_type


func set_enemy_type(type):
	enemy_type = type


# Called when the node enters the scene tree for the first time.
func _ready():
	if enemy_type == ENEMY_TYPES.ANGEL:
		hp_label.rect_position += Vector2(0, -40)
		atk_label.rect_position += Vector2(0, 30)
		def_label.rect_position += Vector2(0, 30)
	elif enemy_type ==ENEMY_TYPES.BOSS: 
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
		ENEMY_TYPES.WEAK:
			sprite.texture = preload("res://game/assets/slime_green.png")
		ENEMY_TYPES.GREEN:
			sprite.texture = preload("res://game/assets/slime_green.png")
		ENEMY_TYPES.BLUE:
			sprite.texture = preload("res://game/assets/slime_blue.png")
		ENEMY_TYPES.PINK:
			sprite.texture = preload("res://game/assets/slime_pink.png")
		ENEMY_TYPES.ANGEL:
			sprite.texture = preload("res://game/assets/ladyangel.png")
		ENEMY_TYPES.BOSS:
			sprite.texture = preload("res://game/assets/ladyangel_black.png")
		ENEMY_TYPES.BOSS_PHT:
			sprite.texture = preload("res://game/assets/ladyangel_black_phantom.png")
		ENEMY_TYPES.Green_1:
			sprite.texture = preload("res://game/assets/slime_green.png")	
		ENEMY_TYPES.Blue_1:
			sprite.texture = preload("res://game/assets/slime_blue.png")
		ENEMY_TYPES.Pink_1:
			sprite.texture = preload("res://game/assets/slime_pink.png")	
		ENEMY_TYPES.Bonus_1:
			sprite.texture = preload("res://game/assets/slime_green.png")	
		ENEMY_TYPES.Green_2:
			sprite.texture = preload("res://game/assets/slime_green.png")	
		ENEMY_TYPES.Blue_2:
			sprite.texture = preload("res://game/assets/slime_blue.png")
		ENEMY_TYPES.Pink_2:
			sprite.texture = preload("res://game/assets/slime_pink.png")	
		ENEMY_TYPES.Green_3:
			sprite.texture = preload("res://game/assets/slime_green.png")	
		ENEMY_TYPES.Blue_3:
			sprite.texture = preload("res://game/assets/slime_blue.png")
		ENEMY_TYPES.Pink_3:
			sprite.texture = preload("res://game/assets/slime_pink.png")
		ENEMY_TYPES.Bonus_2:
			sprite.texture = preload("res://game/assets/slime_blue.png")		



func initialize_stats():
	match enemy_type:
		ENEMY_TYPES.WEAK:
			health = 5
			max_health = 5
			attack = 10
			defense = 5
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
		ENEMY_TYPES.PINK:
			health = 15
			max_health = 15
			attack = 30
			defense = 20
		ENEMY_TYPES.ANGEL:
			health = 999
			max_health = 999
			attack = 999
			defense = 999
		ENEMY_TYPES.BOSS:
			health = '??'
			max_health = '??'
			attack = '??'
			defense = '??'
		ENEMY_TYPES.BOSS_PHT:
			health = ''
			max_health = ''
			attack = ''
			defense = ''
		ENEMY_TYPES.Green_1:
			health = 15
			max_health = 15
			attack = 35
			defense = 20
		ENEMY_TYPES.Blue_1:
			health = 15
			max_health = 20
			attack = 40
			defense = 30
		ENEMY_TYPES.Pink_1:
			health = 15
			max_health = 15
			attack = 45
			defense = 35
		ENEMY_TYPES.Bonus_1:
			health = 1
			max_health = 1
			attack = 19
			defense = 34
		ENEMY_TYPES.Green_2:
			health = 60
			max_health = 60
			attack = 50
			defense = 20
		ENEMY_TYPES.Blue_2:
			health = 35
			max_health = 35
			attack = 60
			defense = 15
		ENEMY_TYPES.Pink_2:
			health = 40
			max_health = 40
			attack = 80
			defense = 10
		ENEMY_TYPES.Green_3:
			health = 10
			max_health = 10
			attack = 70
			defense = 70
		ENEMY_TYPES.Blue_3:
			health = 35
			max_health = 35
			attack = 60
			defense = 15
		ENEMY_TYPES.Pink_3:
			health = 5
			max_health = 5
			attack = 90
			defense = 80
		ENEMY_TYPES.Bonus_2:
			health = 1
			max_health = 1
			attack = 49
			defense = 79


func update_labels():
	$HPLabel.text = String(health) + "/" + String(max_health)
	$ATKLabel.text = String(attack)
	$DEFLabel.text = String(defense)




func _on_Area2D_mouse_entered():
	emit_signal("mouse_entered_pawn")


func _on_Area2D_mouse_exited():
	emit_signal("mouse_left_pawn")
