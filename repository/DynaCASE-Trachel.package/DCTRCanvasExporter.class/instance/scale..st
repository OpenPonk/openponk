settings
scale: aScale
	"1 = defaultScale"

	canvas morph extent: canvas morph extent * aScale / canvas camera scale.
	canvas camera doWithoutCallbacks: [ canvas camera scale: aScale ]