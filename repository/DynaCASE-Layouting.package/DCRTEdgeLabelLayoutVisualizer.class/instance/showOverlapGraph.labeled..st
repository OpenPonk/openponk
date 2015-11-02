visualization
showOverlapGraph: aGraph labeled: aString
	| b bg lbl |
	b := RTMondrian new.
	b view: view.
	b shape ellipse
		size: 20;
		color: Color white;
		borderColor: Color black;
		withText:
			[ :m | 
			m isFeature
				ifTrue: [ m label copyFrom: 3 to: 4 ]
				ifFalse:
					[ m isPosition
						ifTrue: [ m index ]
						ifFalse:
							[ m isCluster
								ifTrue: [ (m model collect: #label) asArray joinUsing: '-' ]
								ifFalse: [ 'unknown node' ] ] ] ].
	b nodes: aGraph nodes.
	b edges useAssociations: (aGraph edges collect: [ :each | each from -> each to ]).
	b layout tree horizontalGap: 30.
	b build.
	b edges shape attachPoint: #withContinuousRectangleAttachPoint.
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