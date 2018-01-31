testing
isValid
	^ textEditorMorph text ifNil: [ false ] ifNotNil: [ :text | validation value: text ]