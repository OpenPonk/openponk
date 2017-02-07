running
setUp
	view := RTView new.
	source := RTBox new
		size: 30;
		element.
	target := RTBox new
		size: 30;
		element.
	view add: source.
	view add: target.
	source translateTo: 0 @ 0.
	target translateTo: 100 @ 100.
	self createEdgeAnchor.
	self createConnectionAnchor