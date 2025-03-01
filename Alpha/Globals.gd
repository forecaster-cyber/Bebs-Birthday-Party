extends Node


var socially_curious = 0.5
var q_asked = 0
var t_listening_laughing = 0
var t_listening_crying = 0
var t_listening_fighting = 0
var distance_travelled = 0
var non_curious_interactions = 0
var t_looking_laughing = 0
var t_looking_crying = 0
var t_looking_fighting = 0
var t_idle = 0
var first_interaction = ""
var t_talking_crying = 0
var id = ""
var logs = []
var p_logs = []
var isTalking = false
var age = 0
var gender = 0
var current_talker = 0
var p_is_curious = 0.5
var highlights: Node
var highlights_distractions: Node
var highlights_npc: Node
var highlight_question = false
signal highlight_question_signal(show)
var highlight_trick = false
signal highlight_trick_signal(show)
signal highlight_actions_now(actions)
signal hide_arrows()
var is_dynamic_game = false
var action_weights = {
	"ask_question_beb": 0.05,
	"ask_question_arguing": 0.04,
	"distraction_gun": -0.03,
	"distraction_present": -0.035,
	"trick_beb": -0.052,
	"trick_arguing": -0.053,
	"enter_listen_bubble_girls": 0.045,
	"enter_listen_bubble_beb": 0.048,
	"enter_listen_bubble_arguing": 0.051,
	"activate_balloon": -0.05,
	"activate_radio": -0.05,
	"activate_gun": -0.05,
	"activate_present": -0.05,
	#"start_talk": 0.21
}

var current_probs = {"curious": p_is_curious, "not_curious": 1-p_is_curious}

func calculate_kl_divergence(p, q):
	# KL Divergence formula: sum(p[i] * log(p[i] / q[i]))
	print("P is: " + str(p))
	print("Q is: " + str(q))
	var kl_div = 0.0
	for key in p.keys():
		if p[key] > 0.0 and q[key] > 0.0:
			kl_div += q[key] * log(q[key] / p[key])
	return kl_div

func _process(delta):
	#if(highlight_question):
	#	highlight_question_signal.emit(true)
	#	print("showing arrow!!")
	#else:
	#	highlight_question_signal.emit(false)
	#	print("showing arrow!!")
	#if(highlight_trick):
	#	highlight_trick_signal.emit(true)
	#	print("showing arrow!!")
	#else:
	#	highlight_trick_signal.emit(false)
	#	print("showing arrow!!")
	pass
func update_probabilities(action):
	# Update probabilities based on action weights
	var weight = action_weights.get(action, 0.0)
	
	# Temporarily calculate new probabilities
	var new_curious = current_probs["curious"] + weight
	var new_not_curious = current_probs["not_curious"] - weight
	
	# Clip probabilities to ensure they remain within [0, 1]
	new_curious = clamp(new_curious, 0.0, 1.0)
	new_not_curious = clamp(new_not_curious, 0.0, 1.0)
	
	# Ensure the two probabilities sum to 1
	var total = new_curious + new_not_curious
	if total > 0:
		new_curious /= total
		new_not_curious /= total
	
	# Update the current probabilities
	current_probs["curious"] = new_curious
	current_probs["not_curious"] = new_not_curious
	
	# Store the final probability of being curious
	p_is_curious = current_probs["curious"]



func get_best_next_actions():
	var kl_divergences = {}
	
	# Test each action and calculate KL divergence
	for action in action_weights.keys():
		var temp_probs = current_probs.duplicate()
		var weight = action_weights[action]
		temp_probs["curious"] += weight
		temp_probs["not_curious"] -= weight
		
		# Normalize
		var total = temp_probs["curious"] + temp_probs["not_curious"]
		temp_probs["curious"] /= total
		temp_probs["not_curious"] /= total
		
		kl_divergences[action] = calculate_kl_divergence(current_probs, temp_probs)
	
	# Sort actions by KL divergence and return the top 2
	var sorted_pairs = kl_divergences.keys()
	print("POOP " + str(sorted_pairs))
	print("POOP4 " + str(kl_divergences))
	print("POOP5 " + str(p_is_curious))
	sorted_pairs.sort_custom(func(a, b): return kl_divergences[a] > kl_divergences[b])
	print("POOP2 " + str(sorted_pairs))
	print("POOP3 " + str(sorted_pairs[0], sorted_pairs[1]))
	# Extract the top two actions (keys)
	return [sorted_pairs[0], sorted_pairs[1]]
	

func perform_action(action):
	update_probabilities(action)
	hide_arrows.emit()
	print("LOLOLO" + str(current_probs))
	print("hahahahahahahha" + str(get_best_next_actions()))


func highlight_actions():
	if(is_dynamic_game):
		var best_actions = get_best_next_actions()
		highlight_actions_now.emit(best_actions)
	#if(best_actions[0] == "ask_question_beb" || best_actions[0] == "enter_listen_bubble" || best_actions[1] == "ask_question_bebw" || best_actions[1] == "enter_listen_bubble"):
	#	highlights.visible = true
	#	highlights_npc.visible = true
		#highlights_distractions.visible = false
	#if (best_actions[0] == "distraction_gun" || best_actions[0] == "activate" || best_actions[1] == "distraction_gun" || best_actions[1] == "activate"):
	#	highlights.visible = true
	#	highlights_distractions.visible = true
		#highlights_npc.visible = false
	# Add your logic to visually highlight the actions in the game
		print("Highlight these actions: ", best_actions)
		
	else:
		pass
