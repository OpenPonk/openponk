saving
autoSave: aMemento
	disableAutosave
		ifTrue: [ ^ self ].
	lastSave ifNil: [ ^ self ].
	self project fileName ifNil: [ ^ self ].
	(lastSave at: #autosave)
		at: aMemento id asString
		put:
			(Dictionary
				with: #dateTime -> DateAndTime now truncated asString
				with: #graph -> (#DCFsmGraphML asClass new export: aMemento model withLayout: aMemento layout)).
	self saveState: lastSave to: self project fileName