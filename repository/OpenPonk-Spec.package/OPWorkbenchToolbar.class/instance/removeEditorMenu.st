menus for editor
removeEditorMenu
	toolbar menuGroups size = 2
		ifTrue: [ toolbar menuGroups remove: toolbar menuGroups last ]