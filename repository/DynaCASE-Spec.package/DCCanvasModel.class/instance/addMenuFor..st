adding
addMenuFor: aFigure
	| menu |
	menu := PluggableMenuSpec new model: aFigure.
	menu add: 'Delete' action: (MessageSend receiver: self selector: #deleteFigure: argument: aFigure);
		add: 'Inspect' action: (MessageSend receiver: self selector: #inspectFigure: argument: aFigure);
		add: 'Rename' action: (MessageSend receiver: self selector: #renameFigure: argument: aFigure)
		. 
	aFigure when: TRMouseRightClick do: [ :event | menu asMenuMorph popUpInWorld ]