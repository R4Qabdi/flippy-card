extends Node2D

var cards_in_hand = []
var cards_in_opp_hand = []
var CARD_WIDTH = 56
const HAND_YPOS_OFFSET = 125
const HAND_XPOS_OFFSET = 100
const HAND_YPOS_OFFSET_OPP = -125
const MARGIN_X =0

const DRAW_AMOUNT = 8

var viewport_rect_x

func _ready() -> void:
	randomize()
	#draw 5 cards to player
	for n in range(DRAW_AMOUNT):
		#var randomfromdeck = randi_range(0, global.cards_in_deck_id.size()-1)
		draw_card(global.cards_in_deck_id.pop_at(randi_range(0, global.cards_in_deck_id.size()-1)), 1)
		#draw_card(14,1)
		#draw_card(11,1)
		global.playerhand = cards_in_hand
		#global.cards_in_deck_id.remove_at(randomfromdeck)
		update_deck()
		await delay(0.2)
		#randomfromdeck = randi_range(0, global.cards_in_deck_id.size()-1)
		draw_card(global.cards_in_deck_id.pop_at(randi_range(0, global.cards_in_deck_id.size()-1)), 2)
		#draw_card(14,2)
		global.opphand = cards_in_opp_hand
		#global.cards_in_deck_id.remove_at(randomfromdeck)
		update_deck()
		await delay(0.2)
		if n == DRAW_AMOUNT-1:
			enable_cards()
				

func draw_card(id,forwho):
	
	var cardscene = preload("res://scenes/core/card.tscn")
	var newcard = cardscene.instantiate()
	#unewcard=newcard
	newcard.name = str(id)
	newcard.id = id
	newcard.position = $"../deck".position
	if forwho == 1:
		newcard.selectable = false
		newcard.is_facing_up = true
		$"../cardhandler".add_child(newcard)
		cards_in_hand.append(newcard)
		update_new_card_pos()
	elif forwho == 2:
		newcard.selectable = false
		newcard.is_facing_up = false
		
		$"../opphand".add_child(newcard)
		cards_in_opp_hand.append(newcard)
		update_new_card_pos_for_opp()

func update_deck():
	if global.cards_in_deck_id.size() > 0:
		if global.cards_in_deck_id.size() >= 39 and global.cards_in_deck_id.size() <= 52:
			$"../deck/textures".frame = 0
		elif global.cards_in_deck_id.size() >= 26 and global.cards_in_deck_id.size() <= 38:
			$"../deck/textures".frame = 1
		elif global.cards_in_deck_id.size() >= 13 and global.cards_in_deck_id.size() <= 25:
			$"../deck/textures".frame = 2
		elif global.cards_in_deck_id.size() >= 1 and global.cards_in_deck_id.size() <= 13:
			$"../deck/textures".frame = 3
	else:
		$"../deck".visible = false

func update_new_card_pos():
	CARD_WIDTH = 400/cards_in_hand.size()
	for i in cards_in_hand.size():
		var totalwidth =400
		var x_offset = i * CARD_WIDTH - totalwidth/2 +HAND_XPOS_OFFSET-56
		var finalpos = Vector2(x_offset,HAND_YPOS_OFFSET)
		#var totalwidth = cards_in_hand.size()*(CARD_WIDTH + MARGIN_X)
		#var x_offset = i * CARD_WIDTH - totalwidth/2 +HAND_XPOS_OFFSET
		#var finalpos = Vector2(x_offset,HAND_YPOS_OFFSET)
		#print("-------"+str(cards_in_hand.size())+"---------")
		#print(x_offset)
		#print("kartu biasa")
		#ganti anunya biar bisa dia di ambil tanpa ambil yang lain aduhai
		var ukuran 
		if cards_in_hand.size()>0:
			#print(cards_in_hand[cards_in_hand.size()-1])
			cards_in_hand[cards_in_hand.size()-1].change_area_size(12)
		slide(cards_in_hand[i],cards_in_hand[i].position,finalpos,0.2)
		
func update_new_card_pos_for_opp():
	CARD_WIDTH = 400/cards_in_opp_hand.size()
	for i in cards_in_opp_hand.size():
		var totalwidth =400
		var x_offset = i * CARD_WIDTH - totalwidth/2 +HAND_XPOS_OFFSET
		var finalpos = Vector2(x_offset,HAND_YPOS_OFFSET_OPP)
		#var totalwidth = cards_in_opp_hand.size()*(CARD_WIDTH + MARGIN_X)
		#var x_offset = i * CARD_WIDTH - totalwidth/2 +HAND_XPOS_OFFSET
		#var finalpos = Vector2(x_offset,HAND_YPOS_OFFSET_OPP)
		#print("kartu lawan")
		#print("-------"+str(cards_in_opp_hand.size())+"---------")
		#print(x_offset)
		slide(cards_in_opp_hand[i],cards_in_opp_hand[i].position,finalpos,0.2)

func enable_cards():
	await delay(0.2)
	for i in cards_in_hand:
		i.selectable = true

func slide(node, from, to, duration) -> Tween:
	node.position = from
	var tween = create_tween()
	tween.tween_property(node, "position", to, duration).set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	return tween

func delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
