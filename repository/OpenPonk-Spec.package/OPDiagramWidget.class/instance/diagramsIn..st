accessing
diagramsIn: aProject
	^ aProject models
		sorted: [ :a :b | 
			a class name = b class name
				ifTrue: [ a name < b name ]
				ifFalse: [ a class name < b class name ] ]