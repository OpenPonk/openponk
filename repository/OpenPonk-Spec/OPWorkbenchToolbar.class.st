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
				subMenu: self addEditorMenuItems ]
]

{ #category : #'menus for editor' }
OPWorkbenchToolbar >> addEditorMenuItems [

	| menu |
	menu := self newMenu.
	self
		addEditorMenuItems: ((PragmaMenuBuilder
				  pragmaKeyword: #opEditorToolbarMenu
				  model: activeEditor)
				 buildTree;
				 itemList)
		to: menu.

	self
		addEditorMenuItems: ((OPPragmaPluginMenuBuilder
				  pragmaKeyword: #opEditorToolbarMenu:
				  model: activeEditor)
				 buildTree;
				 itemList)
		to: menu.

	^ menu
]

{ #category : #'menus for editor' }
OPWorkbenchToolbar >> addEditorMenuItems: menuRegistrations to: spMenu [

	| itemEndingGroupIndex |
	menuRegistrations ifEmpty: [ ^ spMenu ].
	menuRegistrations last withSeparatorAfter.
	itemEndingGroupIndex := menuRegistrations size.
	spMenu addGroup: [ :group | 
		menuRegistrations withIndexDo: [ :each :index | 
			itemEndingGroupIndex >= index ifTrue: [ 
				group addItem: [ :item | 
					item
						name: each label;
						icon: each spec icon;
						action: [ :arg | 
							each spec action selector ifNotNil: [ 
									each spec action cull: arg ] ].
					(each itemList isNotNil and: [ each itemList isNotEmpty ]) 
						ifTrue: [ 
							| submenu |
							submenu := self newMenu.
							item subMenu: submenu.
							self addEditorMenuItems: each itemList to: submenu ] ].
				each spec separator ifTrue: [ itemEndingGroupIndex := index ] ] ] ].
	^ self
		  addEditorMenuItems:
		  (menuRegistrations allButFirst: itemEndingGroupIndex)
		  to: spMenu
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
						action: [ 
							browser := SettingBrowser new
								           changePackageSet: { #'OpenPonk-Spec' asPackage };
								           yourself.
							path := (browser open submorphs detect: [ :each | 
								         each isKindOf: MorphTreeMorph ]) nodeList.
							browser expandNodePath: path first contents first path ] ];
				addItem: [ :item | 
					item
						name: 'Check for new version';
						icon: (self iconNamed: #smallUpdate);
						action: [ 
							(OPUpdater newApplication: SpApplication defaultApplication)
								open ] ] ];
		addGroup: [ :group | 
			group addItem: [ :item | 
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
