accessing
vertexElementType: aVertex
	| type types |
	(types := Dictionary new)
		at: DCSmPseudostateKind initial put: 'InitialState';
		at: DCSmPseudostateKind deepHistory put: 'HistoryState';
		at: DCSmPseudostateKind shallowHistory put: 'HistoryState';
		at: DCSmPseudostateKind exitPoint put: 'RegionEndState';
		at: DCSmPseudostateKind terminate put: 'SeqDestroyMark';
		at: DCSmPseudostateKind choice put: '	Decision'.
	(aVertex isMemberOf: DCSmFinalState)
		ifTrue: [ type := 'FinalState' ].
	(aVertex isMemberOf: DCSmState)
		ifTrue: [ 
			aVertex isSubmachineState
				ifTrue: [ type := 'StateSubDiagram' ]
				ifFalse: [ type := 'State' ] ].
	(aVertex isMemberOf: DCSmPseudostate)
		ifTrue: [ type := types at: aVertex kind ].
	^ 'com.umlet.element.custom.' , type