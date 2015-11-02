visualization
showClusters: clusterGraphs labeled: aString
	| b bg lbl |
	b := RTMondrian new.
	b view: view.
	b shape rectangle withTextAbove: [ :m | m nodes joinUsing: '-' ].
	b
		nodes: clusterGraphs
		forEach:
			[ :graph | 
			b shape circle size: 20; color: Color white; withText: #index.
			b nodes: graph nodes.
			b edges useAssociations: (graph edges collect: [ :each | each from -> each to ]).
			b layout tree horizontalGap: 30 ].
	b build.
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