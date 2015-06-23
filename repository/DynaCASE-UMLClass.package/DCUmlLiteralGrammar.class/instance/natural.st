grammar-literals
natural
	^ #digit asParser plus flatten trim ==> [ :nodes | nodes asNumber ]