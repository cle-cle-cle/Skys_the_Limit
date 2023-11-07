extends VBoxContainer

onready var hp = $HP
onready var atk = $ATK
onready var def = $DEF


func _ready():
	update_labels()


func _process(delta):
	update_labels()


func update_labels():
	hp.text = String(PlayerStats.health) + "/" + String(PlayerStats.max_health)
	atk.text = String(PlayerStats.attack)
	def.text = String(PlayerStats.defense)
