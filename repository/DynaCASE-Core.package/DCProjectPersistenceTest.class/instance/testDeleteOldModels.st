tests
testDeleteOldModels
	| models folder |
	folder := FileSystem memory root / 'models'.
	models := {(DCNamedElement named: 'first').
	(DCNamedElement named: 'second')}.
	persistence
		saveMemento: (DCPersistenceMemento model: models first diagram: nil)
		to: folder
		with: DCStonSerializer new.
	persistence
		saveMemento: (DCPersistenceMemento model: models second diagram: nil)
		to: folder
		with: DCStonSerializer new.
	self assert: folder children size equals: 2.
	persistence removeModelsNotIn: models allButLast from: folder.
	self assert: folder children size equals: 1.
	self assert: folder children anyOne basename equals: models first uuid asString