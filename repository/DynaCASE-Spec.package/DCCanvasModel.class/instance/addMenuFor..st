adding
addMenuFor: aFigure
	| menu |
	menu := PluggableMenuSpec new model: aFigure.
	menu add: 'Delete' action: (MessageSend receiver: self selector: #deleteFigure: argument: aFigure).
	aFigure when: TRMouseRightClick do: [ :event | menu asMenuMorph popUpInWorld ]