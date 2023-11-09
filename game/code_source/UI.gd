extends CanvasLayer


onready var enemy_stats_h_box = $EnemyStatsHBox


func update_enemy_stats_box(enemy):
	$EnemyStatsHBox/TextureRect.texture = enemy.sprite.texture
	$EnemyStatsHBox/EnemyStatsVBox/HP.text = String(enemy.health) + "/" + String(enemy.max_health)
	$EnemyStatsHBox/EnemyStatsVBox/ATK.text = String(enemy.attack)
	$EnemyStatsHBox/EnemyStatsVBox/DEF.text = String(enemy.defense)

