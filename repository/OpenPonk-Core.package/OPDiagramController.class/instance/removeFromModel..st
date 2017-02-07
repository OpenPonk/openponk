removing
removeFromModel: aModel
	"Remove aModel from the diagram.
	It is aModel's owner's controller responsibility to remove it.
	The assertion tests whether aModel is attached to the current controller chain.
	"

	self assert: (self controllerForModel: aModel) model = aModel.
	(self controllerForModel: aModel owner) removeModelElement: aModel