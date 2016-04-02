opening
openEditorOn: aDiagram
	| editor tab plugin widget |
	(self projectController hasDiagram: aDiagram)
		ifTrue: [ ^ self ].
	(editor := DCEditor new) workbench: self.
	plugin := pluginRegistry pluginFor: aDiagram.
	editor plugin: plugin.
	tab := self newTab.
	widget := editor buildWithSpec asWidget.
	editor owner: tab.
	editor openDiagram: aDiagram.
	aDiagram whenChanged: [ tab label: aDiagram name ].
	editor paletteModel rebuildWidget.
	tab
		label: aDiagram name;
		icon: plugin icon;
		retrievingBlock: [ widget ];
		whenTabSelected: [ topToolbar activeEditor: editor ];
		whenBuiltDo: [ :w | 
			w widget when: #tabDeleted send: #tabDeleted to: editor.
			w widget when: #tabDeleted evaluate: [ :t | topToolbar activeEditor: nil ] ].
	tabManager addTab: tab