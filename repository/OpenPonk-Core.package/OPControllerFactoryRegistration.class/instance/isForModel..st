accessing
isForModel: aModel
	^ aModel class = self modelClass and: [ self condition value: aModel ]