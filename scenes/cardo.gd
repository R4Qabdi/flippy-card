extends Node2D

signal hover
signal hover_exit
@export var id:int

func _ready() -> void:
	$textures.frame = id
	get_parent().connect_card_signals(self)

func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hover", self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hover_exit", self)
