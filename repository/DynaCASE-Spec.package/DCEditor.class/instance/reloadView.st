as yet unclassified
reloadView
	diagramController view: roassalView.
	diagramController rebuild.
	roassalView elements
		do: [ :each | 
			each
				on: TRMouseLeftClick
				do: [ :event | self viewElementClicked: event ] ].
	roassalView edges
		do: [ :each | 
			each
				on: TRMouseLeftClick
				do: [ :event | self viewEdgeClicked: event ] ]