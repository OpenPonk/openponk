settings
scale: aScale
	"1 = defaultScale"

	self
		extent: self extent * aScale / self cameraScale;
		cameraScale: aScale