extends Node2D

const deck = [
  "AS","2S","3S","4S","5S","6S","7S","8S","9S","10S","JS","QS","KS",
  "AH","2H","3H","4H","5H","6H","7H","8H","9H","10H","JH","QH","KH",
  "AD","2D","3D","4D","5D","6D","7D","8D","9D","10D","JD","QD","KD",
  "AC","2C","3C","4C","5C","6C","7C","8C","9C","10C","JC","QC","KC"
]
var list_of_cards = deck
var is_hover = false
var on_cooldown = false

signal deckhover
signal deckexithover

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() and is_hover and !on_cooldown:
			if global.cards_in_deck_id.size() > 0:
				if global.cards_in_deck_id.size() >= 39 and global.cards_in_deck_id.size() <= 52:
					$textures.frame = 0
				elif global.cards_in_deck_id.size() >= 26 and global.cards_in_deck_id.size() <= 38:
					$textures.frame = 1
				elif global.cards_in_deck_id.size() >= 13 and global.cards_in_deck_id.size() <= 25:
					$textures.frame = 2
				elif global.cards_in_deck_id.size() >= 1 and global.cards_in_deck_id.size() <= 13:
					$textures.frame = 3
				if $"../cardhandler".playercoins > 0 :
					var randomfromdeck = randi_range(0, global.cards_in_deck_id.size()-1)
					$"../playerhand".draw_card(global.cards_in_deck_id[randomfromdeck], 1)
					$"../cardhandler".playercoins -= 1
					$"../playerhand".enable_cards()
					$"../coinflip/point/Label".text = str($"../cardhandler".playercoins)
					$cooldown.start(0.2)
					$"../options/both/Label".text = "-1 coin"
					$"../anim".queue("ondeck")
					on_cooldown=true
				else:
					$"../options/both/Label".text = "not enough coins"
					$"../anim".queue("ondeck")
			else: self.visible = false


func _on_area_mouse_entered() -> void:
	#print("hover")
	$hover.visible = true
	emit_signal("deckhover")
	is_hover = true

func _on_area_mouse_exited() -> void:
	#print("nohover")
	$hover.visible = false
	emit_signal("deckexithover")
	is_hover = false

func _on_cooldown_timeout() -> void:
	on_cooldown=false
	
