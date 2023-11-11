extends CanvasLayer


onready var enemy_stats = $EnemyStats


func update_enemy_stats_box(enemy):
	$EnemyStats/EnemyStatsHBox/TextureRect.texture = enemy.sprite.texture
	$EnemyStats/EnemyStatsHBox/EnemyStatsVBox/HP.text = String(enemy.health) + "/" + String(enemy.max_health)
	$EnemyStats/EnemyStatsHBox/EnemyStatsVBox/ATK.text = String(enemy.attack)
	$EnemyStats/EnemyStatsHBox/EnemyStatsVBox/DEF.text = String(enemy.defense)
