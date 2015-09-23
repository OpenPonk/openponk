userinterface
rebuild
	| figures edges |
	super rebuild.
	figures := self controllers
		select: [ :each | each isKindOf: DCFsmVertexController ]
		thenCollect: #figure.
	edges := (figures flatCollect: #connectedEdges) reject: [ :each | each from = each to ].

	RTHorizontalTreeLayout new
		horizontalGap: 50;
		verticalGap: 50;
		doNotAttachPoint;
		on: figures edges: edges.

	self view canvas camera focusOnCenter