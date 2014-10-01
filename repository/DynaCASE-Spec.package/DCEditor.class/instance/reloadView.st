as yet unclassified
reloadView
	diagramController view: roassalView.
	diagramController rebuild.
	diagramController controllers
		do: [ :ctrl | 
			| element |
			element := ctrl view.
			(element isKindOf: RTElement)
				ifTrue: [ 
					element
						on: TRMouseLeftClick
						do: [ :event | self viewElementClicked: event ] ].
			(element isKindOf: RTEdge)
				ifTrue: [ 
					element
						on: TRMouseLeftClick
						do: [ :event | self viewEdgeClicked: event ] ] ]