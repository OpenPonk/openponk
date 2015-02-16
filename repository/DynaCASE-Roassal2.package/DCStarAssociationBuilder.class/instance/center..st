setting
center: aPoint
	"center will be always at aPoint, until changed via this method again or set to dynamic centering"

	dynamicCentering := false.
	^ centerDragBox translateTo: aPoint