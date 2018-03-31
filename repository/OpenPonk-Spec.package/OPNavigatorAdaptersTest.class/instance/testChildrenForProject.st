running
testChildrenForProject
	| project |
	project := OPProject new.
	project addModel: Object new.
	self assert: (adapters childrenFor: project) asArray equals: project models asArray