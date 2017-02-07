hooks
createModel
	^ self model ifNil: [ self modelClass new ]