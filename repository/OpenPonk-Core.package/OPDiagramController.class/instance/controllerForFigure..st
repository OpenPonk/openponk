controllers management
controllerForFigure: aFigure
	^ self cachedControllerForFigure: aFigure
	"^ self controllers detect: [ :ctrl | ctrl figure = aFigure ]"