adding
addMenuFor: aFigure
	aFigure
		when: TRMouseRightClick
		do: [ :event | 
			| menu |
			menu := CmdContextMenuActivation
				buildContextMenuFor: self
				inContext: (OPDiagramFigureContext for: self of: aFigure).
			menu popUpInWorld ]