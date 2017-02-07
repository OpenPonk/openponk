saving
newSaveData
	lastSave := Dictionary
		with: #dateTime -> DateAndTime now truncated asString
		with: #project -> (Dictionary with: #name -> self project name)
		with: #autosave -> Dictionary new
		with: #diagrams -> self serializedDiagrams.
	^ lastSave