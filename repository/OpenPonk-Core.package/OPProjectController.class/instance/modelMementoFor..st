saving
modelMementoFor: aModel
	^ controllers
		detect: [ :each | each model = aModel ]
		ifFound: #memento
		ifNone: [ OPPersistenceMemento model: aModel diagram: nil ]