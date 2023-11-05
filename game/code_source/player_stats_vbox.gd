extends VBoxContainer

onready var hp = $HP
onready var max_hp = $MaxHP
onready var atk = $ATK
onready var def = $DEF


func _ready():
	update_labels()


func _process(delta):
	update_labels()


func update_labels():
	hp.text = " HP:" + String(PlayerStats.health) + "/" + String(PlayerStats.max_health)
	max_hp.text = " MAX HP:" + String(PlayerStats.max_health)
	atk.text = " ATK: " + String(PlayerStats.attack)
	def.text = " DEF: " + String(PlayerStats.defense)
