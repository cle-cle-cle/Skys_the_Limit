class_name Pawn extends Node2D

signal mouse_entered_pawn
signal mouse_left_pawn

enum CELL_TYPES{ ACTOR, UPGRADE, GROUND, ENEMY, STAIR, COLLAPSE }
export(CELL_TYPES) var type = CELL_TYPES.ACTOR

