extends Node2D

const CARD_PATH = "res://scenes/core/card.tscn"
const CARD_SIZE = Vector2(56,96) 
const HAND_Y_POSITION = 80
var toggle :bool = false

var playerhand = []
var center_screen_x 

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug-n"):
		draw_card_to_hand()

func draw_card(id):
	var card = preload(CARD_PATH)
	var new_card = card.instantiate()
	$"../cardholder".add_child(new_card)
	if id:
		new_card.id = id
	new_card.position = get_local_mouse_position()

func draw_card_to_hand():
	var cardscene = preload(CARD_PATH)
	var new_card = cardscene.instantiate()
	$"../cardholder".add_child(new_card)
	new_card.name = "card"
	new_card.id = 23
	playerhand.insert(0,new_card)
	update_hand_position()

func update_hand_position():
	for i in range(playerhand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)

func calculate_card_position(index):
	center_screen_x = get_viewport().size.x/2
	var total_width = (playerhand.size()-1)*CARD_SIZE.x
	var x_offset = center_screen_x + index * CARD_SIZE.x - total_width /2
	return x_offset

func _on_draw_text_submitted(text: String) -> void:
	draw_card(text)

func _on_rng_pressed() -> void:
	draw_card(randi_range(1,52))

func _on_cf_pressed() -> void:
	toggle = !toggle
	if toggle :
		if randi_range(0,1):
			$"../cf".text = "cf : tails"
		else : 
			$"../cf".text = "cf : heads"
	else : 
		$"../cf".text = "coinflip"


func _on_counterup_pressed() -> void:
	$"../point/Label".text = str(int($"../point/Label".text)+1) 

func _on_counterdown_pressed() -> void:
	$"../point/Label".text = str(int($"../point/Label".text)-1) 

func _on_oppcounterup_pressed() -> void:
	$"../opppoint/Label".text = str(int($"../opppoint/Label".text)+1)

func _on_oppcounterdown_pressed() -> void:
	$"../opppoint/Label".text = str(int($"../opppoint/Label".text)-1)
