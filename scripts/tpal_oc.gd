extends Resource
class_name TPalOC

@export var hover_time: float
@export var hover_open: bool = true
@export var hover_exit: bool = true
@export var click_open: bool = false
@export var click_exit: bool = false

func mouse_enter(tpal : Control):
	TPalManager.add_child(
		tpal
	)
	pass
	
	
func mouse_exit(tpal : Control):
	tpal.queue_free()
	pass

