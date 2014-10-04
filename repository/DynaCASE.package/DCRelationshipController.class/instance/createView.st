hooks
createView
	| fromCtrl toCtrl edge |
	fromCtrl := self parent findControllerByModel: self model source.
	toCtrl := self parent findControllerByModel: self model target.
	edge := self createEdgeFrom: fromCtrl view to: toCtrl view.
	^ edge