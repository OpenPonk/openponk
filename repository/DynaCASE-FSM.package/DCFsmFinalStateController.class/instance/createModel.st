accessing
createModel
	^ self model
		ifNil: [ 
			self modelClass new
				beFinal;
				yourself ]