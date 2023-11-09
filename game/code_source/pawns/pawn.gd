class_name Pawn extends Node2D


enum CELL_TYPES{ ACTOR, UPGRADE, GROUND, ENEMY, STAIR, COLLAPSE }
export(CELL_TYPES) var type = CELL_TYPES.ACTOR
