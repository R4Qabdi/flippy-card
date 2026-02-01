extends Node2D
const MOUSE_RAY_MASK = 1<<1
var playerbettedcard
var oppbettedcard
var randpick
func _ready() -> void:
	pass # Replace with function body.

func connect_card_signals(card):
	card.connect("hover", on_card_hover)
	card.connect("hover_exit", on_card_exit_hover)

func on_card_hover(card):
	#print("hovering "+card.name+" |posisinya "+str(card.get_node("textures").position.y))
	card.get_node("textures").position.y = 0
	slide(card.get_node("textures"), card.get_node("textures").position,Vector2(card.get_node("textures").position.x,card.get_node("textures").position.y-10),0.2)#biar bisa lebih ke kanan fungsi dari komen ini

func on_card_exit_hover(card):
	#print("unhovering "+card.name+" |posisinya "+str(card.get_node("textures").position.y))
	card.get_node("textures").position.y = -10
	slide(card.get_node("textures"), card.get_node("textures").position,Vector2(card.get_node("textures").position.x,card.get_node("textures").position.y+10),0.2)

func slide(node, from, to, duration) -> Tween:
	node.position = from
	var tween = create_tween()
	tween.tween_property(node, "position", to, duration).set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	return tween

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var card = mouse_raycast()
			
			#print(card)
			if card :
				playerbettedcard = card
				card.selectable = false
				card.get_node("textures/hover").visible = false
				card.get_node("textures").position.y = 0
				
				handle(card, "player")
				randpick = randi_range(0,$"../playerhand".cards_in_opp_hand.size()-1)
				oppbettedcard = $"../playerhand".cards_in_opp_hand[randpick]
				oppbettedcard.get_node("textures").position.y = 0
				handle(oppbettedcard,"opp")
				await delay(1)
				coinflip()

func coinflip():
	var cfp = randi_range(0,1)
	var cfo = randi_range(0,1)
	print(str(cfp) + "-" + str(cfo))
	#print(playerbettedcard)
	#print(oppbettedcard)
	await delay(1)
	if cfp and cfo:
		slide(playerbettedcard, playerbettedcard.position, $"../cardslot/foropp".position, 0.2)
		slide(oppbettedcard, oppbettedcard.position, $"../cardslot/forplayer".position, 0.2)
		oppbettedcard.selectable = true
		$"../playerhand".cards_in_hand.insert(randi_range(0,$"../playerhand".cards_in_hand.size()-1), oppbettedcard)
		$"../playerhand".update_new_card_pos()
		
		$"../playerhand".cards_in_opp_hand.insert(randi_range(0,$"../playerhand".cards_in_opp_hand.size()-1), playerbettedcard)
		playerbettedcard.change_facing()
		$"../playerhand".update_new_card_pos_for_opp()
	if !cfp and !cfo:
		slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
		slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
	if cfp and !cfo:
		print("yah you vin vro")
		slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
		slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
	if !cfp and cfo:
		print("unfortunatley you loast")
		slide(playerbettedcard, playerbettedcard.position, $"../sampah".position, 0.2)
		slide(oppbettedcard, oppbettedcard.position, $"../sampah".position, 0.2)
	

func handle(card, who):
	match who:
		"player":
			$"../playerhand".cards_in_hand.erase(card)
			$"../playerhand".update_new_card_pos()
			slide(card, card.position, $"../cardslot/forplayer".position, 0.2)
		"opp":
			$"../playerhand".cards_in_opp_hand[randpick].change_facing()
			$"../playerhand".cards_in_opp_hand.erase($"../playerhand".cards_in_opp_hand[randpick])
			$"../playerhand".update_new_card_pos_for_opp()
			slide(card, card.position, $"../cardslot/foropp".position, 0.2)
			

func mouse_raycast():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = MOUSE_RAY_MASK
	var result = space_state.intersect_point(parameters)
	if result.size() > 0 :
		if result[0].collider.get_parent().selectable:
			return result[0].collider.get_parent()
	return null

func delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
