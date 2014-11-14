settings
canvas: aCanvas
	"sets canvas for export, resets all settings"

	canvas := aCanvas veryDeepCopy.
	canvas morph
		ifNil: [ 
			canvas buildMorph.
			self whole ]