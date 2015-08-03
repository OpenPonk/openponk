private
applyOversize
	"permanently adds selected oversize to size of canvas"

	self extent: self extent + (self cameraScale * oversize)