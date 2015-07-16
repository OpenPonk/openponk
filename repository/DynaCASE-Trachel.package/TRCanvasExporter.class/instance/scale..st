settings
scale: aScale
	"Setting applied immediately.
	Resizes image and its content to aScale
	1 = defaultScale
	2 = 200% zoom in"

	self
		extent: self extent * aScale / self cameraScale;
		cameraScale: aScale