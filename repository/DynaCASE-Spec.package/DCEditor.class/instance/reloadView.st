as yet unclassified
reloadView
	diagramController view: roassalView.
	diagramController rebuild.
	diagramController controllers
		do: [ :ctrl | 
			| element |
			element := ctrl view.
			(element isKindOf: RTElement)
				ifTrue: [ element when: TRMouseLeftClick do: [ :event | self viewElementClicked: event element ] ].
			(element isKindOf: RTEdge)
				ifTrue: [ 
					element
						when: TRMouseLeftClick
						do: [ :event | 
							"TODO: pass 'event element' once fixed in roassal"
							self viewEdgeClicked: element ] ] ].
	roassalView canvas addMenu: '  + ' callback: [ RTZoomInMove on: roassalView ].
	roassalView canvas addMenu: ' -  ' callback: [ RTZoomOutMove on: roassalView ].
	roassalView @ DCRTScrollableView.
	diagramController updateView