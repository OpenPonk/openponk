removing
removeFromView: aFigure
	"Remove an object represented by aFigure from the model.
	It is object's owner's controller responsibility to remove the object."

	| removedModel |
	removedModel := (self controllerForFigure: aFigure) model.
	(self controllerForModel: removedModel owner) removeModelElement: removedModel