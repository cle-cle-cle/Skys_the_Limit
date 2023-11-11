tool
class_name Upgrade extends Pawn

onready var label = $Label


# Upgrad stats
enum UPGRADE_TYPES{ HP, MHP, ATK, DEF, ATK_MUL, DEF_MUL }
export(UPGRADE_TYPES) var upgrade_type = UPGRADE_TYPES.HP setget set_upgrade_type
export var value = 1 setget set_value


func set_upgrade_type(type):
	upgrade_type = type


func set_value(v):
	value = v


func _ready():
	update_labels()


func update_labels():
	match upgrade_type:
		UPGRADE_TYPES.HP:
			label.text = "HP" + "\n" + "+" + String(value)
		UPGRADE_TYPES.MHP:
			label.text = "MHP" + "\n" + "+" + String(value)
		UPGRADE_TYPES.ATK:
			label.text = "ATK" + "\n" + "+" +  String(value)
			label.modulate = "#c0d9ff"
		UPGRADE_TYPES.DEF:
			label.text = "DEF" + "\n" + "+" +  String(value)
			label.modulate = "#ccffc5"
		UPGRADE_TYPES.ATK_MUL:
			label.text = "ATK" + "\n" + "x" +  String(value)
			label.modulate = "#c0d9ff"
		UPGRADE_TYPES.DEF_MUL:
			label.text = "DEF" + "\n" + "x" +  String(value)
			label.modulate = "#ccffc5"


func interact():
	match upgrade_type:
		UPGRADE_TYPES.HP:
			PlayerStats.health = clamp(PlayerStats.health + value, 0, PlayerStats.max_health)
		UPGRADE_TYPES.MHP:
			PlayerStats.max_health += value
		UPGRADE_TYPES.ATK:
			PlayerStats.attack += value
		UPGRADE_TYPES.DEF:
			PlayerStats.defense += value
		UPGRADE_TYPES.ATK_MUL:
			PlayerStats.attack *= value
		UPGRADE_TYPES.DEF_MUL:
			PlayerStats.defense *= value

