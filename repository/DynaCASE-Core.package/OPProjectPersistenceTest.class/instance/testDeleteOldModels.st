tests
testDeleteOldModels
	| models folder |
	folder := FileSystem memory root / 'models'.
	models := {(OPNamedElement named: 'first').
	(OPNamedElement named: 'second')}.
	persistence
		saveMemento: (OPPersistenceMemento model: models first diagram: nil)
		to: folder
		with: OPStonSerializer new.
	persistence
		saveMemento: (OPPersistenceMemento model: models second diagram: nil)
		to: folder
		with: OPStonSerializer new.
	self assert: folder children size equals: 2.
	persistence removeModelsNotIn: models allButLast from: folder.
	self assert: folder children size equals: 1.
	self assert: folder children anyOne basename equals: models first uuid asString