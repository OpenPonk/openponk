widget API
displayMapping
	^ {(DCFsm -> 'Diagram').
	(DCFsmInitialState -> 'Initial State').
	(DCFsmState
		-> [ :o | 
			o isNormal
				ifTrue: [ 'State' ]
				ifFalse: [ 'Final State' ] ]).
	(DCFsmTransition -> 'Transition')}