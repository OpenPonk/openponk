hooks
loadModel
	self model ifNil: [ self model: self createModel ].
	^ self model