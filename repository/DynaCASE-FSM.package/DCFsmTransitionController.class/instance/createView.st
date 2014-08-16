hooks
createView
	| fromCtrl toCtrl |
	fromCtrl := self parent findControllerByModel: self model source.
	toCtrl := self parent findControllerByModel: self model target.
	view := viewBlock value: fromCtrl view value: toCtrl view value: self parent view.
	^ view