visualization
showMatchingGraph: aGraph labeled: aString
	| b bg lbl |
	b := RTMondrian new.
	b view: view.
	b shape rectangle
		withTextAbove:
			[ :m | 
			m isFeature
				ifTrue: [ m label copyFrom: 3 to: 4 ]
				ifFalse: [ m model nodes joinUsing: '-' ] ].
	b
		nodes: aGraph nodes
		forEach:
			[ :node | 
			b shape circle
				size: 20;
				color: Color white;
				withText: #index.
			node isFeature
				ifTrue: [ b nodes: #() ].
			node isCluster
				ifTrue:
					[ b nodes: node model nodes.
					b edges useAssociations: (node model edges collect: [ :each | each from -> each to ]) ].
			b layout tree ].
	b edges useAssociations: (aGraph edges collect: [ :each | each from -> each to ]).
	b layout dominanceTree horizontalGap: 30.
	b build.
	b edges shape attachPoint: #withContinuousCircleAttachPoint.
	bg := RTBox new element.
	view add: bg.
	bg @ RTDraggable.
	lbl := RTLabel new
		color: Color black;
		elementOn: aString.
	view add: lbl.
	RTNest new on: bg nest: b topElements , {lbl}.
	bg trachelShape pushBack.
	bg translateBy: 0 @ 100