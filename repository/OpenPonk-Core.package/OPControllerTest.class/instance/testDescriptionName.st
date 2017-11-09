tests
testDescriptionName
	model := Mock new.
	model stub name willReturn: 'bravo'.
	controller model: model.
	self stubRefresh.
	controller descriptionName accessor write: 'charlie' to: controller.
	model should receive name: 'charlie'.
	self assert: (controller descriptionName accessor read: controller) equals: 'bravo'.
	controller should receive refreshFigure