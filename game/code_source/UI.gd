extends CanvasLayer


onready var enemy_stats = $EnemyStats
onready var restart_level_button = $RestartLevelButton
onready var restart_game_button = $RestartGameButton


# Save player stats from last level
var saved_health = 100
var saved_max_health = 100
var saved_attack = 5
var saved_defense = 5


func _ready():
	# save player stats in the begining of the game
	save_player_stats()


func save_player_stats():
	# save player stats in the begining of the level, so we can revert back to this stat when restart level
	saved_health = PlayerStats.health
	saved_max_health = PlayerStats.max_health
	saved_attack = PlayerStats.attack
	saved_defense = PlayerStats.defense
	


func update_enemy_stats_box(enemy):
	$EnemyStats/EnemyStatsHBox/TextureRect.texture = enemy.sprite.texture
	$EnemyStats/EnemyStatsHBox/EnemyStatsVBox/HP.text = String(enemy.health) + "/" + String(enemy.max_health)
	$EnemyStats/EnemyStatsHBox/EnemyStatsVBox/ATK.text = String(enemy.attack)
	$EnemyStats/EnemyStatsHBox/EnemyStatsVBox/DEF.text = String(enemy.defense)


func _on_RestartLevelButton_pressed():
	# Reset All Player Stats to Saved Stats
	PlayerStats.health = saved_health
	PlayerStats.max_health = saved_max_health
	PlayerStats.attack = saved_attack
	PlayerStats.defense = saved_defense

	get_tree().reload_current_scene()
	


func _on_RestartGameButton_pressed():
	# Reset All Player Stats
	PlayerStats.health = 100
	PlayerStats.max_health = 100
	PlayerStats.attack = 5
	PlayerStats.defense = 5
	
	get_tree().change_scene("res://game/code_source/levels/Level_0.tscn")

