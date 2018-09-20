accessing
model
	self
		assert: [ self project isNotNil ]
		description: 'Cannot retrieve model of a detached view.'.
	^ self project models
		detect: [ :each | 
			each typeName = self modelType
				and: [ each name = self modelName and: [ each version = self modelVersion ] ] ]