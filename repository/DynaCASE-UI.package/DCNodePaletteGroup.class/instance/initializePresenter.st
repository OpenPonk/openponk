initialization
initializePresenter
	| element |
	textButton
		action: [ 
			(element := DCVisualText new) text: 'DynaCASE'.
			self onAction value: element ]