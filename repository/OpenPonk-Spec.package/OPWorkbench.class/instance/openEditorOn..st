opening
openEditorOn: aModel
	| editor tab plugin widget |
	(self projectController hasDiagram: aModel)
		ifTrue: [ self focusEditorOf: aModel.
			^ self ].
	(editor := OPEditor new) workbench: self.
	plugin := pluginRegistry pluginFor: aModel.
	editor plugin: plugin.
	tab := self newTab.
	editors at: aModel put: (Array with: editor with: tab).
	widget := editor buildWithSpec asWidget.
	editor owner: tab.
	editor openModel: aModel.
	(aModel respondsTo: #whenChanged:)
		ifTrue: [ aModel whenChanged: [ tab label: aModel name ] ].
	editor paletteModel rebuildWidget.
	tab
		label: aModel name;
		icon: plugin icon;
		retrievingBlock: [ widget ];
		whenTabSelected: [ topToolbar activeEditor: editor ];
		whenBuiltDo: [ :w | 
			w widget when: #tabDeleted send: #tabDeleted to: editor.
			w widget
				when: #tabDeleted
				evaluate: [ :t | 
					topToolbar activeEditor: nil.
					editors removeKey: aModel ] ].
	tabManager addTab: tab.
	self focusEditorOf: aModel