tests
testCreateModel
	| ctrl model |
	ctrl := self createController.
	model := ctrl createModel.
	self assert: model class = DCFsmInitialState