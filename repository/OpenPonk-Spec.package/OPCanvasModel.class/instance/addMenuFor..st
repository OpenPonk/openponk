adding
addMenuFor: aFigure
	aFigure
		when: TRMouseRightClick
		do: [ :event | 
			| menu |
			self lastClickPosition: event position.
			self diagramController selectFigure: event element.
			self lastSelectedFigure: event element.
			menu := CmdContextMenuActivation
				buildContextMenuFor: self
				inContext: (OPDiagramFigureContext for: self of: self selectedElements).
			menu popUpInWorld ]