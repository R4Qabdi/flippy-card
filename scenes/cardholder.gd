extends Node2D

const MOUSE_RAY_MASK = 1
const CARD_IDLE_SCALE = Vector2(2,2)
const CARD_HOVERED_SCALE = Vector2(2.1,2.1)
const CARD_PICKUP_Y_OFFSET = -36
var screen_size 
var dragged_card
var is_over_card

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if dragged_card:
		var mouse_pos = get_global_mouse_position() + Vector2(0,CARD_PICKUP_Y_OFFSET)
		dragged_card.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), clamp(mouse_pos.y, 0, screen_size.y)) 

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var card = take_card()
			if card:
				on_card_drag(card)
		else:
			on_card_exit_drag()

func take_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = MOUSE_RAY_MASK
	var result = space_state.intersect_point(parameters)
	if result.size() > 0 :
		#return result[0].collider.get_parent()
		return get_card_highest_z(result)
	return result

func get_card_highest_z(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card

func connect_card_signals(card):
	card.connect("hover", on_card_hover)
	card.connect("hover_exit", on_card_exit_hover)

func on_card_drag(card):
	dragged_card = card
	card.scale = Vector2(CARD_IDLE_SCALE)

func on_card_exit_drag():
	if dragged_card:
		dragged_card.scale = Vector2(CARD_HOVERED_SCALE)
	dragged_card = null
	
func on_card_hover(card):
	if !is_over_card:
		is_over_card = true
		
		select_card(card, true)

func on_card_exit_hover(card):
	if !dragged_card:
		is_over_card = false
		select_card(card, false)
		var new_card_hovered = take_card()
		if new_card_hovered:
			select_card(new_card_hovered, true)
		else:
			is_over_card = false


func select_card(card, hover):
	if hover:
		card.scale = CARD_HOVERED_SCALE
		card.z_index = 2
	else : 
		card.scale = CARD_IDLE_SCALE
		card.z_index = 1
