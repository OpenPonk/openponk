building widgets
alignButtons
	"align content of all buttons to left"

	items
		select: [ :each | (each isKindOf: OPPaletteEntry) and: [ each widget isNotNil ] ]
		thenDo: [ :each | each widget widget submorphs first listCentering: #topLeft ]