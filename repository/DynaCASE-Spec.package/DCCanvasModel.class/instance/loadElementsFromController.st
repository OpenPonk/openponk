private
loadElementsFromController
	diagramController rebuild.
"	diagramController controllers
		do: [ :ctrl | 
			| element |
			element := ctrl figure.
			self figureAdded: element ]"