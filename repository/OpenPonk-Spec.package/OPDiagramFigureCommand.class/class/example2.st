example
example2
	| c a |
	c := OPCanvasModel new.
	a := CmdContextMenuActivation
		buildContextMenuFor: c
		inContext: (OPDiagramFigureContext for: c).
	a openInWindow