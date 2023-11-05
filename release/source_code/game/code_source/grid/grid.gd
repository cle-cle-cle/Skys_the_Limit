extends TileMap

enum { EMPTY = -1, ACTOR, UPGRADE, GROUND, ENEMY, STAIR, COLLAPSE }

signal entered_stair

onready var actor = $Actor
onready var collapse_order = $CollapseOrder
onready var collapse_sprite_container = $CollapseSpriteContainer


onready var collapse_sprite = preload("res://game/code_source/CollapseSprite.tscn")


func _ready():
	mark_pawns()
	mark_collapsing_cell(0)


# Map all pawn child nodes to tile grid
func mark_pawns():
	for child in get_children():
		if "type" in child:
			set_cellv(world_to_map(child.position), child.type)


# Mark collapsing cells of this turn, those cells will collpase before the next turn
func mark_collapsing_cell(turn):
	if collapse_order.get_child_count() != 0: # don't do this for final level
		for child in collapse_order.get_child(turn).get_children():
			var new_collapse_sprite = collapse_sprite.instance()
			new_collapse_sprite.position = map_to_world(world_to_map(child.rect_position)) + Vector2(32, 32)
			collapse_sprite_container.add_child(new_collapse_sprite)


func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)


func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
	match cell_target_type:
		GROUND, COLLAPSE, ACTOR: #actor is extra here, just contains the player's initial position
			# Move Actor
			print("ground")
			return update_pawn_position(pawn, cell_start, cell_target)
		UPGRADE:
			if get_cell_pawn(cell_target):
				var upgrade_pawn = get_cell_pawn(cell_target)
				print("Cell %s contains %s" % [cell_target, upgrade_pawn.name])
				upgrade_pawn.interact()
				upgrade_pawn.queue_free()
				$"../AudioBuff".play()
			# Move Actor
			return update_pawn_position(pawn, cell_start, cell_target)
		ENEMY:
			if get_cell_pawn(cell_target):
				var enemy_pawn = get_cell_pawn(cell_target)
				print("Cell %s contains %s" % [cell_target, enemy_pawn.name])
				# Attack Enemy
				enemy_pawn.health = clamp(enemy_pawn.health + enemy_pawn.defense - PlayerStats.attack, 0, enemy_pawn.health)
				$"../AudioHit".play()
				if enemy_pawn.health <= 0:
					enemy_pawn.queue_free()
					set_cellv(cell_target, GROUND)
				else:
					# Enemy is not dead, get Damaged by Enemy
					PlayerStats.health = clamp(PlayerStats.health + PlayerStats.defense - enemy_pawn.attack, 0, PlayerStats.health)
			else:
				# Enemy no longer here, just move Actor
				return update_pawn_position(pawn, cell_start, cell_target)
		STAIR:
			print("stair")
			emit_signal("entered_stair")
			
			
		EMPTY:
			pass # Do not walk on empty cells

func update_pawn_position(pawn, cell_start, cell_target):
	#set_cellv(cell_target, pawn.type)
#	set_cellv(cell_start, GROUND)
	return map_to_world(cell_target) + cell_size / 2


func collapse_ground(current_turn):
	print(current_turn)
	for cell in collapse_order.get_child(current_turn).get_children():
		# check if there are other objects on this cell, remove them
		# but don't remove actor, because it might be moving
		for pawn in get_children():
			if "type" in pawn:
				if pawn.type == ACTOR:
					continue
				if world_to_map(cell.rect_position) == world_to_map(pawn.position):
					pawn.queue_free()
		# set the grid cell to EMPTY
		set_cellv(world_to_map(cell.rect_position), EMPTY)
	
	for child in collapse_sprite_container.get_children():
		child.queue_free()
		



func _on_Actor_landed_on_new_pos():
	if get_cellv(world_to_map(actor.position)) == EMPTY:
		actor.queue_free()
