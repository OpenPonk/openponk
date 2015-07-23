*DynaCASE-Roassal2-to-migrate
translateLeftOf: element to: newPosition
	"Translate the left side of the element"

	self translate: element to: newPosition @ element position y direction: 1 @ 0.