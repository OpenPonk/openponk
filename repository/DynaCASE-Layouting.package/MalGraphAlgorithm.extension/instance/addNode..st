*DynaCASE-Layouting
addNode: aNode
	^ self findNode: aNode model ifAbsent: [ nodes add: aNode ]