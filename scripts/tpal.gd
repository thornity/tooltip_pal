@icon("res://addons/tooltip_pal/icons/comment.svg")
class_name TPal
extends Control

var tpal_manager: TPalManager = TPalManager

@export var position_from: Control

## What & where is the box
@export var tpal_draw: TPalDraw = preload("res://addons/tooltip_pal/resources/tpal_draw_default.tres")

## The actions & state of the box
@export var tpal_oc: TPalOC = preload("res://addons/tooltip_pal/resources/tpal_oc_default.tres")

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	tpal_draw.viewport = Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y)	
	pass

func _on_mouse_entered():
	
	var position_from: Node
	
	if position_from != null:
		position_from = self.position_from
	else:
		position_from = get_parent()
	
	tpal_manager.add_child(
		tpal_draw.panel_stuff(position_from)
	)
		
	pass

func _on_mouse_exited():
	tpal_draw.tooltip.queue_free()
	pass
