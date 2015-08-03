settings
whole
	"Setting applied immediately.
	Changes extent to include whole canvas, otherwise it is cropped to original camera or to size set by #extent:"

	self
		centered;
		extent: self cameraScale * canvas encompassingRectangle extent