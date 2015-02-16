private
cameraScale: aScale
	"changes scale of content of image, but does not resize its extent (use #scale: for that)"

	canvas camera doWithoutCallbacks: [ canvas camera scale: aScale ]