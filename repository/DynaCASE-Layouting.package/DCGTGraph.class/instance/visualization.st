visualization
visualization
	| b |
	b := RTMondrian new.
	b shape ellipse borderColor: Color gray; color: Color transparent; size: 17; withText: [ :node | node model ].
	b nodes: self nodes.
	b shape bezierLineFollowing: [ :node | self edgesFor: node ].
	b edges useAssociations: (self edges collect: [ :each | each from -> each to ]).
	b layout dominanceTree
		horizontalGap: 20;
		verticalGap: 100.
	b build.
	^ b view