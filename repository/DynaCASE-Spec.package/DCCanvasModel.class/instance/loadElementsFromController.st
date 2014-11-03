private
loadElementsFromController
	diagramController rebuild.
	diagramController controllers
		do: [ :ctrl | 
			| element |
			element := ctrl view.
			self figureAdded: element ]