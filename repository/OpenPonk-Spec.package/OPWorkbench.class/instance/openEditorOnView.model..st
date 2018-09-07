opening
openEditorOnView: aView model: aModel
	| editor tab plugin widget |
	(self projectController hasView: aView)
		ifTrue: [ ^ self focusEditorOf: aView ].
	plugin := pluginRegistry pluginFor: aModel.
	editor := OPEditor on: plugin.
	editor workbench: self.
	tab := self newTab.
	editors at: aView put: (Array with: editor with: tab).
	widget := editor buildWithSpec asWidget.
	editor owner: tab.
	editor openEmptyModel: aModel.
	(aModel respondsTo: #whenChanged:)
		ifTrue: [ aModel whenChanged: [ tab label: aModel name ] ].
	editor paletteModel rebuildWidget.
	tab
		label: '[', aView name , '] ' , aModel name;
		icon: plugin icon;
		retrievingBlock: [ widget ];
		whenBuiltDo: [ :w | 
			w widget when: #tabDeleted send: #tabDeleted to: editor.
			w widget when: #tabDeleted evaluate: [ :t | self closeEditor: editor ] ].
	self announce: (OPEditorCreated on: editor).
	tabManager addTab: tab.
	self focusEditorOf: aView.
	editor applyView: aView