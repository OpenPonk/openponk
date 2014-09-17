hooks
renderIn: aView
	| lineLabel callback |
	super renderIn: aView.
	
	lineLabel := TRLabelShape new text: lineName value.
	callback := TRRemoveCallback new block: [ :shape | lineLabel remove ].
	edge trachelShape addCallback: callback.

	
	
	aView add: edge.