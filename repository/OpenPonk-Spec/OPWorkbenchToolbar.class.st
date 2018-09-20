"
I am top menu toolbar for Workbench.
"
Class {
	#name : #OPWorkbenchToolbar,
	#superclass : #DynamicComposableModel,
	#instVars : [
		'toolbar',
		'activeEditor'
	],
	#category : 'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPWorkbenchToolbar class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :row | row add: #toolbar ];
		yourself
]

{ #category : #'project menu' }
OPWorkbenchToolbar class >> projectToolbarMenu: aBuilder [
	<opProjectSubmenu>
	| workbenchToolbar |
	workbenchToolbar := aBuilder model.
	(aBuilder group: #ProjectOpening)
		order: 0;
		with: [ (aBuilder item: 'New')
				icon: Smalltalk ui icons smallNew;
				enabled: false;
				order: 1;
				action: [ OPProjectBrowser open ].
			(aBuilder item: 'Open...')
				icon: Smalltalk ui icons smallOpen;
				order: 5;
				action: [ workbenchToolbar projectController openProject ].
			(aBuilder item: 'Save')
				icon: Smalltalk ui icons smallSave;
				order: 10;
				action: [ workbenchToolbar projectController saveProject ] ];
		withSeparatorAfter.
	(aBuilder group: #ProjectOptions)
		order: 1000;
		with: [ (aBuilder item: 'Properties...')
				icon: Smalltalk ui icons configuration;
				action: [ workbenchToolbar projectController project maEdit ] ];
		withSeparatorAfter.
	(aBuilder group: #Quit)
		order: 9999;
		with: [ (aBuilder item: 'Exit')
				icon: Smalltalk ui icons smallQuit;
				action: [ workbenchToolbar workbench delete ] ]
]

{ #category : #'menus for editor' }
OPWorkbenchToolbar >> activeEditor: anEditor [
	activeEditor := anEditor.
	activeEditor ifNil: [ self removeEditorMenu ] ifNotNil: [ self addEditorMenu ].
	self rebuildWidget
]

{ #category : #'menus for editor' }
OPWorkbenchToolbar >> addEditorMenu [
	self removeEditorMenu.
	toolbar
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Editor';
						icon: Smalltalk ui icons packageIcon;
						subMenu: self editorMenu ] ]
]

{ #category : #'menus for editor' }
OPWorkbenchToolbar >> editorMenu [
	| menu |
	menu := self instantiate: MenuModel.
	menu
		fromSpec: (PragmaMenuBuilder cachedPragmaKeyword: #opEditorToolbarMenu model: activeEditor) menuSpec.
	menu
		fromSpec:
			(OPPragmaPluginMenuBuilder cachedPragmaKeyword: #opEditorToolbarMenu: model: activeEditor)
				menuSpec.
	"MenuModel is stupid and will crash when provided with an empty subMenu"
	menu menuGroups ifEmpty: [ ^nil ].
	^ menu
]

{ #category : #initialization }
OPWorkbenchToolbar >> initializePresenter [
	toolbar
		autoRefresh: true;
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Project';
						icon: Smalltalk ui icons openIcon;
						subMenu: self projectMenu ] ].
	toolbar applyTo: self
]

{ #category : #initialization }
OPWorkbenchToolbar >> initializeWidgets [
	toolbar := self instantiate: MenuModel
]

{ #category : #accessing }
OPWorkbenchToolbar >> projectController [
	^ self workbench projectController
]

{ #category : #'menus for project' }
OPWorkbenchToolbar >> projectMenu [
	| menu builder |
	menu := self instantiate: MenuModel.
	builder := self workbench
		ifNil: [ PragmaMenuBuilder cachedPragmaKeyword: #opProjectSubmenu model: self ]
		ifNotNil: [ OPPragmaPluginMenuBuilder cachedPragmaKeyword: #opProjectSubmenu model: self ].
	menu fromSpec: builder menuSpec.
	^ menu
]

{ #category : #'building widgets' }
OPWorkbenchToolbar >> rebuildWidget [
	self needFullRebuild: false.
	self buildWithSpec
]

{ #category : #'menus for editor' }
OPWorkbenchToolbar >> removeEditorMenu [
	toolbar menuGroups size = 2
		ifTrue: [ toolbar menuGroups remove: toolbar menuGroups last ]
]

{ #category : #'accessing - spec' }
OPWorkbenchToolbar >> toolbar [
	^ toolbar
]

{ #category : #'menus for project' }
OPWorkbenchToolbar >> updateProjectMenu [
	toolbar menuGroups first menuItems first subMenu: self projectMenu.
	self rebuildWidget
]

{ #category : #'accessing - spec' }
OPWorkbenchToolbar >> workbench [
	^ self owner
]
