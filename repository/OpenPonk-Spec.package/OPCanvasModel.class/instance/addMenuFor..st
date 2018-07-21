adding
addMenuFor: aFigure
	| menu |
	menu := CmdContextMenuActivation
		buildContextMenuFor: self
		inContext: (OPDiagramFigureContext for: self of: aFigure).
	aFigure when: TRMouseRightClick do: [ :event | menu popUpInWorld ]