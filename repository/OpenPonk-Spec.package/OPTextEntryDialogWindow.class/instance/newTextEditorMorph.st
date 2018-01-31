instance creation
newTextEditorMorph
	^ super newTextEditorMorph
		changedAction: [ :text | self defaultButton update: #isValid ];
		yourself