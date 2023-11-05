class_name Upgrade extends Pawn

onready var label = $Label


enum UPGRADE_TYPES{ HEALTH, ATK, DEF, ATK_MUL, DEF_MUL }
export(UPGRADE_TYPES) var upgrade_type = UPGRADE_TYPES.HEALTH

# Declare member variables here. Examples:
export var value = 1 


# Called when the node enters the scene tree for the first time.
func _ready():
	update_labels()

func update_labels():
	match upgrade_type:
		UPGRADE_TYPES.HEALTH:
			label.text = "HP" + "\n" + "+" + String(value)
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
		UPGRADE_TYPES.HEALTH:
			PlayerStats.health = clamp(PlayerStats.health + value, 0, PlayerStats.max_health)
		UPGRADE_TYPES.ATK:
			PlayerStats.attack += value
		UPGRADE_TYPES.DEF:
			PlayerStats.defense += value
		UPGRADE_TYPES.ATK_MUL:
			PlayerStats.attack *= value
		UPGRADE_TYPES.DEF_MUL:
			PlayerStats.defense *= value

