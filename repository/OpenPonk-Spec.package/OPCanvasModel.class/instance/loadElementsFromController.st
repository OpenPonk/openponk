private
loadElementsFromController
	diagramController rebuild.
	diagramController applyDefaultLayout.
"	diagramController controllers
		do: [ :ctrl | 
			| element |
			element := ctrl figure.
			self figureAdded: element ]"