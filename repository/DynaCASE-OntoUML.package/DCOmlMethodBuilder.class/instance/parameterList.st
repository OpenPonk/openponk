grammar
parameterList
	^ super parameterList ==> [ :nodes | nodes ifNil: [ OrderedCollection new ] ifNotNil: [ nodes asOrderedCollection ] ]