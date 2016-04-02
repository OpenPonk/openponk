opening
openEditorOn: aModel
	| editor tab plugin widget |
	(self projectController hasDiagram: aModel)
		ifTrue: [ ^ self ].
	(editor := DCEditor new) workbench: self.
	plugin := pluginRegistry pluginFor: aModel.
	editor plugin: plugin.
	tab := self newTab.
	widget := editor buildWithSpec asWidget.
	editor owner: tab.
	editor openModel: aModel.
	aModel whenChanged: [ tab label: aModel name ].
	editor paletteModel rebuildWidget.
	tab
		label: aModel name;
		icon: plugin icon;
		retrievingBlock: [ widget ];
		whenTabSelected: [ topToolbar activeEditor: editor ];
		whenBuiltDo: [ :w | 
			w widget when: #tabDeleted send: #tabDeleted to: editor.
			w widget when: #tabDeleted evaluate: [ :t | topToolbar activeEditor: nil ] ].
	tabManager addTab: tab