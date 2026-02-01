extends Node2D

var cards_in_hand = []
var cards_in_opp_hand = []
const CARD_WIDTH = 56
const HAND_YPOS_OFFSET = 125
const HAND_XPOS_OFFSET = 100
const HAND_YPOS_OFFSET_OPP = -125
const MARGIN_X =0
var viewport_rect_x

func _ready() -> void:
	#draw 5 cards to player
	for n in range(5):
		var randomfromdeck = randi_range(0, global.cards_in_deck_id.size()-1)
		draw_card(global.cards_in_deck_id[randomfromdeck], 1)
		global.playerhand = cards_in_hand
		global.cards_in_deck_id.pop_at(randomfromdeck)
		await delay(0.2)
		randomfromdeck = randi_range(0, global.cards_in_deck_id.size()-1)
		draw_card(global.cards_in_deck_id[randi_range(0, global.cards_in_deck_id.size()-1)], 2)
		global.opphand = cards_in_opp_hand
		global.cards_in_deck_id.pop_at(randomfromdeck)
		await delay(0.2)

func draw_card(id,forwho):
	var cardscene = preload("res://scenes/core/card.tscn")
	var newcard = cardscene.instantiate()
	#unewcard=newcard
	newcard.name = str(id)
	newcard.id = id
	newcard.position = $"../deck".position
	if forwho == 1:
		newcard.selectable = true
		newcard.is_facing_up = true
		$"../cardhandler".add_child(newcard)
		cards_in_hand.insert(0, newcard)
		update_new_card_pos()
	elif forwho == 2:
		newcard.selectable = false
		newcard.is_facing_up = false
		$"../opphand".add_child(newcard)
		cards_in_opp_hand.insert(0, newcard)
		update_new_card_pos_for_opp()

func update_new_card_pos():
	for i in cards_in_hand.size():
		var totalwidth = cards_in_hand.size()*(CARD_WIDTH + MARGIN_X)
		var x_offset = i * CARD_WIDTH - totalwidth/2 +HAND_XPOS_OFFSET
		var finalpos = Vector2(x_offset,HAND_YPOS_OFFSET)
		#print("-------"+str(cards_in_hand.size())+"---------")
		#print(x_offset)
		#print("kartu biasa")
		slide(cards_in_hand[i],cards_in_hand[i].position,finalpos,0.2)
		
func update_new_card_pos_for_opp():
	for i in cards_in_opp_hand.size():
		var totalwidth = cards_in_opp_hand.size()*(CARD_WIDTH + MARGIN_X)
		var x_offset = i * CARD_WIDTH - totalwidth/2 +HAND_XPOS_OFFSET
		var finalpos = Vector2(x_offset,HAND_YPOS_OFFSET_OPP)
		#print("kartu lawan")
		#print("-------"+str(cards_in_opp_hand.size())+"---------")
		#print(x_offset)
		slide(cards_in_opp_hand[i],cards_in_opp_hand[i].position,finalpos,0.2)


func slide(node, from, to, duration) -> Tween:
	node.position = from
	var tween = create_tween()
	tween.tween_property(node, "position", to, duration).set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	return tween

func delay(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
