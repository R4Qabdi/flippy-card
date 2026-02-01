extends Node2D

signal hover
signal hover_exit
@export var id:int
@export var is_facing_up:bool = true

func _ready() -> void:
	$textures.frame = id
	if !is_facing_up:
		$textures.frame = 55
	get_parent().connect_card_signals(self)

func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	$textures/hover.visible = true
	emit_signal("hover", self)

func _on_area_2d_mouse_exited() -> void:
	$textures/hover.visible = false
	emit_signal("hover_exit", self)

func change_facing():
	is_facing_up = !is_facing_up
	if is_facing_up:
		$textures.frame = id
	else:
		$textures.frame = 55
