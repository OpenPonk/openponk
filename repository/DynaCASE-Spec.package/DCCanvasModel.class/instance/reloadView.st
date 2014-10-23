as yet unclassified
reloadView
	roassalView cleanAll.
	diagramController ifNotNil: [ self loadElementsFromController ].
	roassalView canvas addMenu: '  + ' callback: [ RTZoomInMove on: roassalView ].
	roassalView canvas addMenu: ' -  ' callback: [ RTZoomOutMove on: roassalView ].
	roassalView @ DCRTScrollableView.
	diagramController updateView