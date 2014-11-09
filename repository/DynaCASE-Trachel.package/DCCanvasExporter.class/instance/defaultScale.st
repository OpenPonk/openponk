settings
defaultScale
	canvas morph extent: canvas morph extent / canvas camera scale.
	canvas camera doWithoutCallbacks: [ canvas camera scale: 1.0001 ]