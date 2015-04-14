tests
testCreateModel
	| model |
	ctrl := self createController.
	fromCtrl model: fromCtrl createModel.
	toCtrl model: toCtrl createModel.
	ctrl source: fromCtrl.
	ctrl target: toCtrl.

	model := ctrl createModel.
	self assert: model class = DCFsmTransition.
	self assert: model source = fromCtrl model.
	self assert: model target = toCtrl model