accessing
model
	self
		assert: [ self project isNotNil ]
		description: 'Cannot retrieve model of a detached view.'.
	model ifNotNil: [ ^ model ].
	^ self project class name = #NSPProject
		ifTrue: [ self project models
				detect: [ :each | 
					each typeName = self modelType
						and: [ each name = self modelName and: [ each version = self modelVersion ] ] ] ]
		ifFalse: [ self project models
				detect: [ :each | each class name = self modelType and: [ each name = self modelName ] ] ]