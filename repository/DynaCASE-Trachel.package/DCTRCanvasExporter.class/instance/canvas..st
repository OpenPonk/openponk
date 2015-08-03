settings
canvas: aCanvas
	"sets canvas for export, resets all immediate settings"

	canvas := aCanvas veryDeepCopy.
	canvas morph
		ifNil: [ 
			canvas buildMorph.
			self whole ].
	self initialize