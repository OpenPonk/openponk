construction
createModelIn: aParentModel
	model := self modelClass new.
	model source: sourceController model.
	model target: aParentModel.
	sourceController diagramController model entities add: model