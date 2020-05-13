"
I am top menu toolbar for Workbench.
"
Class {
	#name : #OPWorkbenchToolbar,
	#superclass : #DynamicComposablePresenter,
	#instVars : [
		'toolbar',
		'activeEditor'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPWorkbenchToolbar class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :row | row add: #toolbar ];
		yourself
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
	toolbar menuGroups first
		addItem: [ :item | 
			item
				name: 'Diagram';
				icon: (self iconNamed: #objects);
				subMenu: self editorMenu ]
]

{ #category : #'menus for editor' }
OPWorkbenchToolbar >> editorMenu [
	| menu |
	menu := self instantiate: MenuPresenter.
	menu
		fromSpec:
			(PragmaMenuBuilder
				cachedPragmaKeyword: #opEditorToolbarMenu
				model: activeEditor) menuSpec.
	menu
		fromSpec:
			(OPPragmaPluginMenuBuilder
				cachedPragmaKeyword: #opEditorToolbarMenu:
				model: activeEditor) menuSpec.
	"MenuModel is stupid and will crash when provided with an empty subMenu"
	menu menuGroups ifEmpty: [ ^ nil ].
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
						name: 'OpenPonk';
						icon: (self iconNamed: #home);
						subMenu: self opMenu ];
				addItem: [ :item | 
					item
						name: 'Project';
						icon: (self iconNamed: #openIcon);
						subMenu: self projectMenu ] ].
	toolbar applyTo: self
]

{ #category : #initialization }
OPWorkbenchToolbar >> initializeWidgets [
	toolbar := self instantiate: MenuPresenter
]

{ #category : #'menus for project' }
OPWorkbenchToolbar >> opMenu [
	| menu browser path |
	menu := self instantiate: MenuPresenter.
	menu
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Settings';
						icon: (self iconNamed: #configuration);
						action: [ browser := SettingBrowser new
								changePackageSet: {#'OpenPonk-Spec' asPackage};
								yourself.
							path := (browser open submorphs
								detect: [ :each | each isKindOf: MorphTreeMorph ]) nodeList.
							browser expandNodePath: path first contents first path ] ];
				addItem: [ :item | 
					item
						name: 'Check for new version';
						icon: (self iconNamed: #smallUpdate);
						action: [ [ OPVersion current isMostRecent
								ifTrue: [ GrowlMorph
										openWithLabel: 'Your version is current'
										contents: 'Your version of OpenPonk build is the most recent'
										backgroundColor: Color gray
										labelColor: Color white ]
								ifFalse: [ GrowlMorph
										openWithLabel: 'New version available!'
										contents: 'There is a new version of OpenPonk available on openponk.org'
										backgroundColor: Color yellow
										labelColor: Color black ] ]
								on: Error
								do: [ GrowlMorph
										openWithLabel: 'Failed to check version'
										contents: 'There was an error trying to check for a new version'
										backgroundColor: Color red
										labelColor: Color white ] ] ] ];
		addGroup: [ :group | 
			group
				addItem: [ :item | 
					item
						name: 'Close OpenPonk';
						icon: (self iconNamed: #smallQuit);
						action: [ WorldState saveAndQuit ] ] ].
	^ menu
]

{ #category : #accessing }
OPWorkbenchToolbar >> projectController [
	^ self workbench projectController
]

{ #category : #'menus for project' }
OPWorkbenchToolbar >> projectMenu [
	| menu cmdMenu |
	menu := self instantiate: MenuPresenter.
	cmdMenu := OPWorkbenchActivation buildMenuInContext: (CmdSimpleToolContext for: self).
	cmdMenu buildSpecMenuOn: menu.
	^ menu
]

{ #category : #'building widgets' }
OPWorkbenchToolbar >> rebuildWidget [
	self needFullRebuild: false.
	self buildWithSpec
]

{ #category : #'menus for editor' }
OPWorkbenchToolbar >> removeEditorMenu [
	toolbar menuGroups first menuItems size > 2
		ifTrue: [ toolbar menuGroups first menuItems removeLast ]
]

{ #category : #'accessing - spec' }
OPWorkbenchToolbar >> toolbar [
	^ toolbar
]

{ #category : #'menus for project' }
OPWorkbenchToolbar >> updateProjectMenu [
	toolbar menuGroups first menuItems second subMenu: self projectMenu.
	self rebuildWidget
]

{ #category : #'accessing - spec' }
OPWorkbenchToolbar >> workbench [
	^ self owner
]
