extends Node

var max_level = 2

# Level and steps
export var current_level = 0
var current_turn = 0
var remaining_steps = 0
var steps = [
	[4, 3, 2], # level 0
	[6, 4, 5, 2], # level 1
	[4, 3, 5, 7, 1], # level 2
	[], # level 3
]

# Children
onready var grid = $Grid
onready var actor = $Grid/Actor


# UI
onready var level_label = $CanvasLayer/LevelLabel
onready var turn_label = $CanvasLayer/TurnLabel
#onready var restart_level_button = $CanvasLayer/RestartLevelButton
onready var restart_game_button = $CanvasLayer/RestartGameButton
onready var player_stats_v_box = $CanvasLayer/PlayerStatsVBox


onready var game_over_label = $CanvasLayer/GameOverLabel
onready var dialogue_container = $CanvasLayer/DialogueContainer



# Dialogue
onready var Dialogue = preload("res://game/code_source/Dialogue.tscn")
signal next_clicked
signal current_conversation_ended
var tutorial_dialogue_1 = [
"Hello, my child. I am Lady Angel, queen of the Sky Kingdom.",
]
var tutorial_dialogue_2 = [
"The world is collapsing. Monsters from earth have invaded the Sky Kingdom.",
"Pick up as many blessings as possible to grow stronger, kill the monsters, and save the world.",
"Remeber to check monster's stats before attacking! Do the math or you will die very soon.",
"Left/Blue numbers represent attack. Right/Green numbers represent defense.",
"Take the green slime as an example. It can deal 10 damage and has 1 defense.",
"Pathetic. I can take it down with 1.101101% of my power.",
"But I'll leave it to you.",
"If slime has 10 attack, you have 5 defense, slime deals how many damage to you?",
"...",
"Correct, 5. Good job. ",
"And like a true guardian angel. You will alaways attack first.",
"Kill them before they even notice you. Or become thick enough so that they can't hurt you.",
"And be careful about the dark clouds. They will collapse before the next skyquake.",
"You can only visit a limited number of spaces before the next skyquake.",
"Take 1 step at a time, or you might slip.",
"Be Careful which path you choose.",
]
var tutorial_dialogue_3 = [
	"If you make a mistake, restart by clicking the buttons on top",
	"Unfortunately, you'll have to start from the very begining",
	"Like the hard core games from the old days.",
	"...",
	"Ok, ok.",
	"Developer, add on your TODO list: Make redo button or restart from current level."
]
var boss_dialogue = [
	"You did a good job, but I’m afraid there’s not enough space for both of us."
]


func _ready():
	actor.connect("step_consumed", self, "_on_Actor_step_consumed")
	actor.connect("landed_on_new_pos", grid, "_on_Actor_landed_on_new_pos")
	grid.connect("entered_stair", self, "_on_Grid_entered_stair")
	
	
	# Fresh Turn
	if current_level < 3:
		remaining_steps = steps[current_level][current_turn]
	
	# Initialize UI
	update_labels()
	game_over_label.hide()
	get_tree().paused = false
	
	########################################
	#       Level 0 setup                  #
	#       Tutorial Dialogue              #
	########################################
	if current_level == 0:
		# hide all info at first, and show gradually
		grid.hide()
		player_stats_v_box.hide()
		turn_label.hide()
#		restart_level_button.hide()
		restart_game_button.hide()
		
		play_conversation(tutorial_dialogue_1)
		yield(self, "current_conversation_ended")
		grid.show()
		player_stats_v_box.show()
		turn_label.show()
		
		play_conversation(tutorial_dialogue_2)
		yield(self, "current_conversation_ended")
#		restart_level_button.show()
		restart_game_button.show()
		
		play_conversation(tutorial_dialogue_3)
		yield(self, "current_conversation_ended")
		dialogue_container.hide()
		
	########################################
	#       Level 1 setup                  #
	########################################
	elif current_level == 1:
		dialogue_container.hide()
	########################################
	#       Level 2 setup                  #
	#       Boss Level                     #
	########################################
	elif current_level == 2:
		dialogue_container.show()
		play_conversation(boss_dialogue)
		yield(self, "current_conversation_ended")
		dialogue_container.hide()
	########################################
	#       Level 3 setup                  #
	#       Final Level                    #
	########################################
	elif current_level == 3:
		actor.hp_label.hide()
		actor.atk_label.hide()
		actor.def_label.hide()
		
		# hide everything in UI
		level_label.hide()
		turn_label.hide()
#		restart_level_button.hide()
		restart_game_button.hide()
		player_stats_v_box.hide()
		game_over_label.hide()
		dialogue_container.hide()
		


func _process(delta):
	update_labels()
	
	# Check Game Over
	if PlayerStats.health <= 0 or is_instance_valid(actor) == false:
		# make sure player labels are updated before game over
		if is_instance_valid(actor):
			actor.update_labels() 
		player_stats_v_box.update_labels()
		
		game_over_label.show()
#		restart_level_button.show()
		restart_game_button.show()
		get_tree().paused = true


# Update Level and Steps Labels
func update_labels():
	level_label.text = "LEVEL: " + String(current_level + 1) 
	turn_label.text = "Until Next Collapse: " + String(remaining_steps)


func _on_Actor_step_consumed():
	$AudioWalk.play()
	if current_level < 3: # don;t collapse ground for final level
		remaining_steps -= 1
		if remaining_steps == 0:
			print("turn" + String(current_turn) + "over")
			grid.collapse_ground(current_turn)
			start_new_turn()


func _on_Grid_entered_stair():
	# load next level
	if current_level == max_level:
		# load ending level
		get_tree().change_scene("res://game/code_source/levels/Level_ending.tscn")
	else:
		get_tree().change_scene("res://game/code_source/levels/Level_"+ String(current_level + 1) + ".tscn")


func start_new_turn():
	current_turn += 1
	if current_turn >= steps[current_level].size():
		print("no more turns in this level")
		remaining_steps = 0
	else:
		grid.mark_collapsing_cell(current_turn)
		remaining_steps = steps[current_level][current_turn]


# Restart Level
func _on_RestartButton_pressed():
	# Reset All Player Stats
	PlayerStats.health = 10
	PlayerStats.max_health = 10
	PlayerStats.attack = 10
	PlayerStats.defense = 5

	get_tree().reload_current_scene()


# Restart Game
func _on_RestartGameButton_pressed():
	# Reset All Player Stats
	PlayerStats.health = 10
	PlayerStats.max_health = 10
	PlayerStats.attack = 10
	PlayerStats.defense = 5
	
	get_tree().change_scene("res://game/code_source/levels/Level_0.tscn")



# Dialogue Methods
func play_conversation(coonversation_array):
	var entry = Dialogue.instance()
	dialogue_container.add_child(entry)
	for s in coonversation_array:
#		var tween = create_tween()
#		current_tween = tween
		entry.set_text(s)
#		tween.set_ease(Tween.EASE_IN)
#		tween.tween_property(entry.get_label(), "visible_characters", s.length(), type_speed * s.length())
#		await tween.finished
		
		# wait for input
		yield(self, "next_clicked")
		
#		entry.visible_characters = 0
	
	entry.set_text("")
	entry.is_queued_for_deletion()
	emit_signal("current_conversation_ended")
	
	
	
func _input(event):
	# if player hit "enter" or mouse click, go to next dialogue
	if event is InputEventKey and event.pressed:
		if event.get_scancode() == KEY_ENTER or event.get_scancode() == KEY_SPACE:
#			current_tween.set_speed_scale(10)
			emit_signal("next_clicked")
