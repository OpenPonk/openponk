settings
cameraScale: aScale
	"Setting applied immediately.
	Changes scale of content of image, but does not change its extent (use #scale: for that)"

	canvas camera doWithoutCallbacks: [ canvas camera scale: aScale ]