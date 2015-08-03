settings
scaleToExtent: anExtent
	"Setting applied immediately.
	Sets size of image, scaling canvas to show the same part of canvas (with possible enlarging in one axis based on aspect ratio)."

	| minRatio |
	minRatio := anExtent x / self extent x min: anExtent y / self extent y.
	self
		scale: self cameraScale * minRatio;
		extent: anExtent