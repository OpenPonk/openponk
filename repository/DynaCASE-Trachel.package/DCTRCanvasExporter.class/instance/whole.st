settings
whole
	"image includes whole canvas, otherwise it is cropped to original camera"

	self
		centered;
		extent: self cameraScale * canvas encompassingRectangle extent