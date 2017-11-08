deprecated
createModel
	self deprecated: 'Use createModelIn: instead.'
"	^ self model ifNil: [ self modelClass new ]"