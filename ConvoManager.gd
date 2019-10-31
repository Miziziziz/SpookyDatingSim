extends Control

var vampire_dialog = ["suck me off"]
var ghost_dialog = ["you're super haunt"]
var skeleton_dialog = ["wanna bone"]

var convos = {
	"eat_chips": {
		"text" : "there's some nacho chips and dips here",
		"options": [
			{"text" : "eat chip with guacamole", "send_to": "ate_guac", "set_state": "ate_garlic"},
			{"text" : "eat chip with salsa", "send_to": "ate_salsa"},
			{"text" : "eat chip with hummus", "send_to": "ate_hummus"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"ate_guac": {
		"text" : "yuck! too much garlic",
		"options": [
			{"text" : "eat another chip", "send_to": "eat_chips"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"ate_salsa": {
		"text" : "it's pretty much just tomatoes and corn",
		"options": [
			{"text" : "eat another chip", "send_to": "eat_chips"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"ate_hummus": {
		"text" : "perfectly spiced, very mediterranean",
		"options": [
			{"text" : "eat another chip", "send_to": "eat_chips"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"talk_to_dog": {
		"text": "it's a dog, it's here to be pet",
		"options": [
			{"text": "pet", "send_to": "pet_dog"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"pet_dog" :{
		"text": "the dog recieves your pet and seems pleased",
		"options": [
			{"text": "pet", "send_to": "pet_dog_again"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"pet_dog_again" :{
		"text": "the dog recieves this next pet and seems pleased",
		"options": [
			{"text": "pet", "send_to": "pet_dog"},
			{"text" : "go back to party", "send_to": "close"}
		]
	},
	"talk_to_dog_with_skeleton": {
		"text": "the dog notices some tasty bones...\nSkeleton: ....uhhh",
		"options": [
			{"text" : "Bye", "send_to": "close", "set_state": "dog_chase_skeleton"}
		]
	},
	"talk_to_vampire_after_eating_garlic": {
		"text": "Hey baby how you... ugh what is that awful smell?! \nWatch what you eat if you want guys to like you...",
		"options": [
			{"text" : "Bye", "send_to": "close", "set_state": "set_vampire_flee"}
		]
	},
	"talk_to_witch_while_vampire_following": {
		"text": "You: Hi what's your na-\n*Vampirebro rudely interrupts*\nVampirebro: Hey pumpkin wanna trade roles and suck me off instead?",
		"options": [
			{"text" : "Bye", "send_to": "close"}
		]
	},
	"talk_to_witch_while_skeleton_following": {
		"text": "You: Hi what's your na-\n*Skeletonbro rudely interrupts*\nSkeletonbro: Hey cutey wanna bone?",
		"options": [
			{"text" : "Bye", "send_to": "close"}
		]
	},
	"talk_to_witch_while_ghost_following": {
		"text": "You: Hi what's your na-\n*Ghostbro rudely interrupts*\nGhostbro: Dayummm I'd love to get inside of you!",
		"options": [
			{"text" : "Bye", "send_to": "close"}
		]
	},
	"talk_to_witch": {
		"text": "You: Hi what's your name?",
		"options": [
			{"text" : "have conversation", "send_to": "close", "set_state": "set_complete"}
		]
	}
}

const dialog_option_obj = preload("res://DialogOption.tscn")
var dialog_being_shown = false
func display_dialog(id):
	show()
	dialog_being_shown = true
	var options = [{"text" : "Bye", "send_to": "close"}]
	if id == "witch":
		if StateManager.vampire_following():
			$TextDisplay.text = convos.talk_to_witch_while_vampire_following.text
			options = convos.talk_to_witch_while_vampire_following.options
		elif StateManager.skeleton_following():
			$TextDisplay.text = convos.talk_to_witch_while_skeleton_following.text
			options = convos.talk_to_witch_while_skeleton_following.options
		elif StateManager.ghost_following():
			$TextDisplay.text = convos.talk_to_witch_while_ghost_following.text
			options = convos.talk_to_witch_while_ghost_following.options
		else:
			$TextDisplay.text = convos.talk_to_witch.text
			options = convos.talk_to_witch.options
	elif id == "vampire":
		if StateManager.ate_garlic:
			$TextDisplay.text = "Vampire:\n" + convos.talk_to_vampire_after_eating_garlic.text
			options = convos.talk_to_vampire_after_eating_garlic.options
		else:
			$TextDisplay.text = "Vampire:\n" + pick_random_dialog(vampire_dialog)
	elif id == "ghost":
		$TextDisplay.text = "Ghost:\n" + pick_random_dialog(ghost_dialog)
	elif id == "skeleton":
		$TextDisplay.text = "Skeleton:\n" + pick_random_dialog(skeleton_dialog)
	elif id == "dog":
		if StateManager.skeleton_following():
			display_dialog("talk_to_dog_with_skeleton")
			return
		else:
			display_dialog("talk_to_dog")
			return
	else:
		$TextDisplay.text = convos[id].text
		options = convos[id].options
	
	for old_option in $Options.get_children():
		old_option.queue_free()
	for option in options:
		var new_option = dialog_option_obj.instance()
		new_option.text = option.text
		$Options.add_child(new_option)
		var params = [option.send_to, ""]
		if "set_state" in option:
			params[1] = option.set_state
		new_option.connect("button_up", self, "select_option", params)

func close_convo():
	dialog_being_shown = false
	hide()

func pick_random_dialog(dialog_list):
	return dialog_list[randi() % dialog_list.size()]

func select_option(send_to, set_state):
	if send_to == "close":
		close_convo()
	else:
		display_dialog(send_to)
	
	if set_state != "":
		StateManager.call(set_state)
	