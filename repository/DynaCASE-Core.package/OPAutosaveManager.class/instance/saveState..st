save/load
saveState: aMemento
	future reset.
	current ifNotNil: [ history addLast: current ].
	current := self serializer serializeMemento: aMemento.
	(self autosaveFileFor: aMemento uuid)
		ensureDelete;
		writeStreamDo: [ :stream | 
			stream
				wantsLineEndConversion: true;
				nextPutAll: current ]