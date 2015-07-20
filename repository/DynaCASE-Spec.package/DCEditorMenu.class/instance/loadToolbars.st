initialization
loadToolbars
	(Pragma allNamed: #DCEditorToolbar: in: self canvasModel class)
		do: [ :each | self canvasModel perform: each method selector with: self toolbarModel ].
	(Pragma allNamed: #DCEditorToolbar: in: self editor class)
		do: [ :each | self editor perform: each method selector with: self toolbarModel ].