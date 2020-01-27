"
I am a clickable button entry of the palette.

You can configure both the underlying button and the palette tool through me.
"
Class {
	#name : #OPPaletteEntry,
	#superclass : #ButtonPresenter,
	#instVars : [
		'tool'
	],
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #protocol }
OPPaletteEntry >> deselect [
	tool deselect.
	self state: false
]

{ #category : #'tool api' }
OPPaletteEntry >> factory: aFactoryBlock [
	tool factory: aFactoryBlock
]

{ #category : #initialization }
OPPaletteEntry >> initialize [
	super initialize.
	self action: [ self palette selectEntry: self ].
	self icon:
		(self iconNamed: #blank)
]

{ #category : #accessing }
OPPaletteEntry >> palette [
	^ self owner
]

{ #category : #private }
OPPaletteEntry >> registerShortcut: newShortcut [
	| receiver |
	receiver := self window.
	(receiver isNil or: [ newShortcut isNil ])
		ifTrue: [ ^ self ].

	"ButtonModel binds the shortcut to the Window which means that it will consume any character, which is rather useless when you want to type in a text box. So I selectively check whats the actual target (which is also misreported afaik -_-) and cancel the handling if needed."
	receiver model
		bindKeyCombination: newShortcut
		toAction: [ :target :morph :event | 
			| shouldIgnoreEvent |
			shouldIgnoreEvent := false.
			receiver model formModel form focusOrder
				detect: [ :each | each widget widget hasKeyboardFocus ]
				ifFound: [ :each | 
					(each isKindOf: TextPresenter)
						ifTrue: [ shouldIgnoreEvent := true ] ].
			shouldIgnoreEvent
				ifTrue: [ event wasHandled: false ]
				ifFalse: [ self performAction ] ]
]

{ #category : #protocol }
OPPaletteEntry >> select [
	tool select.
	self state: true
]

{ #category : #accessing }
OPPaletteEntry >> tool [
	^ tool
]

{ #category : #accessing }
OPPaletteEntry >> tool: aTool [
	tool := aTool
]

{ #category : #'tool api' }
OPPaletteEntry >> whenCompleted: aOneArgBlock [
	tool whenCompleted: aOneArgBlock
]

{ #category : #'tool api' }
OPPaletteEntry >> whenCompletedRename [
	self
		whenCompleted: [ :ctrl | 
			OPRenameElementCommand executeOn: ctrl model.
			ctrl refreshFigure ]
]
