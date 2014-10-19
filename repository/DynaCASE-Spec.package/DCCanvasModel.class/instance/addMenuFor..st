adding
addMenuFor: anElement
	| menu |
	menu := PluggableMenuSpec new model: anElement.
	menu add: 'Delete' action: (MessageSend receiver: self selector: #deleteElement: argument: anElement).
	anElement when: TRMouseRightClick do: [ :event | menu asMenuMorph popUpInWorld ]