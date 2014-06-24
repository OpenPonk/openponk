as yet unclassified
processStates: statesCollection
	| xCell yCell trio states |
	xCell := 0.
	yCell := 0.
	states := OrderedCollection new.
	states
		addAll: (self selectInitialStates: statesCollection);
		addAll: (self selectSemiRegularStates: statesCollection);
		addAll: (self selectFinalStates: statesCollection).
	states
		do: [ :state | 
			trio := self generateState: state x: xCell y: yCell.
			self layout add: trio.
			xCell := xCell + 1.
			xCell >= self width
				ifTrue: [ 
					xCell := 0.
					yCell := yCell + 1 ] ]