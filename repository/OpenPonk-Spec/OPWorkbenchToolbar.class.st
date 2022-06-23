"
I am top menu toolbar for Workbench.
"
Class {
	#name : #OPWorkbenchToolbar,
	#superclass : #SpPresenter,
	#instVars : [
		'toolbar',
		'activeEditor'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #'as yet unclassified' }
OPWorkbenchToolbar class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: #toolbar expand: false;
		  yourself
]

{ #category : #specs }
OPWorkbenchToolbar class >> defaultSpec [

	self flag: 'Pharo 9- compatibility'.
	^ self defaultLayout
]

{ #category : #'menus for editor' }
OPWorkbenchToolbar >> activeEditor: anEditor [

	activeEditor := anEditor.
	activeEditor
		ifNil: [ self removeEditorMenu ]
		ifNotNil: [ self addEditorMenu ].
	self update
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

{ #category : #'as yet unclassified' }
OPWorkbenchToolbar >> connectPresenters [

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
	self flag: 'might be removed?'.
	"toolbar applyTo: self"
]

{ #category : #'menus for editor' }
OPWorkbenchToolbar >> editorMenu [

	| menu |
	menu := self newMenu.
	menu addAllFromPragma: #opEditorToolbarMenu target: activeEditor.
	menu addAllFromPragma: #opEditorToolbarMenu: target: activeEditor.
	self flag: 'uncomment if problematic, remove if not'.
	"MenuPresenter is stupid and will crash when provided with an empty subMenu
	menu menuGroups ifEmpty: [ 
		self halt.
		^ nil ]."
	^ menu
]

{ #category : #'as yet unclassified' }
OPWorkbenchToolbar >> initializePresenters [
	toolbar := self newMenuBar
]

{ #category : #'menus for project' }
OPWorkbenchToolbar >> opMenu [
	| menu browser path |
	menu := self newMenu.
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
						action: [ (OPUpdater newApplication: SpApplication defaultApplication)
								openWithSpec ] ] ];
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
	menu := self newMenu.
	cmdMenu := OPWorkbenchActivation buildMenuInContext: (CmdSimpleToolContext for: self).
	cmdMenu buildSpecMenuOn: menu.
	^ menu
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
	self update
]

{ #category : #'accessing - spec' }
OPWorkbenchToolbar >> workbench [
	^ self owner
]
