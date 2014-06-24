as yet unclassified
processTransitions: transitionsCollection
	| trio |
	transitionsCollection
		do: [ :trans | 
			trio := self generateTransition: trans.
			self layout add: trio ]