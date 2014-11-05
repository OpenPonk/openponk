tests
testCreateModel
	| ctrl model fromCtrl toCtrl |
	ctrl := self createController.
	fromCtrl := DCFsmInitialStateController new.
	fromCtrl model: fromCtrl createModel.
	toCtrl := DCFsmFinalStateController new.
	toCtrl model: toCtrl createModel.
	ctrl source: fromCtrl.
	ctrl target: toCtrl.

	model := ctrl createModel.
	self assert: model class = DCFsmTransition.
	self assert: model source = fromCtrl model.
	self assert: model target = toCtrl model