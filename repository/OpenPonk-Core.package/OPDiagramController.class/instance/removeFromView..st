removing
removeFromView: aFigure
	"Right now we remove also from the model, but this is done by an explicit call here."
	
	(self controllerForFigure: aFigure)
		removeModel;
		removeController