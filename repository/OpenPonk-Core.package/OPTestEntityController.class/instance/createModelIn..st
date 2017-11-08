construction
createModelIn: aParentModel
	model := self modelClass new.
	aParentModel entities add: model