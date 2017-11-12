private
loadElementsFromController
	[ World activeHand showTemporaryCursor: Cursor wait.
	World doOneCycle.
	diagramController rebuild.
	diagramController applyDefaultLayout ]
		ensure: [ World activeHand showTemporaryCursor: nil ]
	"	diagramController controllers
		do: [ :ctrl | 
			| element |
			element := ctrl figure.
			self figureAdded: element ]"