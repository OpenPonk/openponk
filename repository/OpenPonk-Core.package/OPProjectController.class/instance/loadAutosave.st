loading
loadAutosave
	| data save askForAutoSave |
	self project fileName ifNil: [ ^ self ].
	data := self loadStateFrom: self project fileName.
	save := DateAndTime fromString: (data at: #dateTime).
	askForAutoSave := (data at: #autosave)
		anySatisfy: [ :each | save < (DateAndTime fromString: (each value at: #dateTime)) ].
	(askForAutoSave
		and: [ UIManager default
				confirm: 'Newer autosaved version of diagram detected.' , String cr , 'Load?' ])
		ifTrue: [ (data at: #autosave)
				keysAndValuesDo: [ :key :value | 
					controllers
						detect: [ :each | each model uuid asString = key ]
						ifFound: [ :ctrl | 
							| dict |
							dict := #OPFsmGraphML asClass new import: (value at: #graph).
							ctrl persistenceManager
								saveState: (#OPFsmPersistenceMemento asClass model: (dict at: #model) layout: (dict at: #layout)).
							ctrl loadState: ctrl persistenceManager loadCurrent ] ] ]