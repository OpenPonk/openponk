as yet unclassified
reloadView
	diagramController view: roassalView.
	diagramController rebuild.
	roassalView elements
		do: [ :each | 
			each
				on: TRMouseLeftClick
				do: [ :event | self viewElementClicked: event ] ]