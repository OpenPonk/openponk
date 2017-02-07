convenience
serializeMemento: aMemento
	^ STON
		toStringPretty:
			(Dictionary
				with: #model -> (self serializeModel: aMemento model)
				with: #diagram -> (self serializeDiagram: aMemento diagram))