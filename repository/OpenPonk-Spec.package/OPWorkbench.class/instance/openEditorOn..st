opening
openEditorOn: aModel
	| editor tab plugin widget |
	self deprecated: 'use openEditorOnView: instead.'.
	(self projectController hasModel: aModel)
		ifTrue: [ ^ self focusEditorOf: aModel ].
	editor := OPEditor new.
	plugin := pluginRegistry pluginFor: aModel.
	editor plugin: plugin.
	editor workbench: self.
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
		whenBuiltDo: [ :w | 
			w widget when: #tabDeleted send: #tabDeleted to: editor.
			w widget when: #tabDeleted evaluate: [ :t | self closeEditor: editor ] ].
	self announce: (OPEditorCreated on: editor).
	tabManager addTab: tab.
	self focusEditorOf: aModel