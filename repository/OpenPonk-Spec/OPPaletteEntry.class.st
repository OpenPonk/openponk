"
I am a clickable button entry of the palette.

You can configure both the underlying button and the palette tool through me.
"
Class {
	#name : 'OPPaletteEntry',
	#superclass : 'SpButtonPresenter',
	#instVars : [
		'tool'
	],
	#category : 'OpenPonk-Spec-Palettes',
	#package : 'OpenPonk-Spec',
	#tag : 'Palettes'
}

{ #category : 'protocol' }
OPPaletteEntry >> deselect [
	tool deselect.
	self state: false
]

{ #category : 'tool api' }
OPPaletteEntry >> factory: aFactoryBlock [
	tool factory: aFactoryBlock
]

{ #category : 'initialization' }
OPPaletteEntry >> initialize [
	super initialize.
	self action: [ self palette selectEntry: self ].
	self icon:
		(self iconNamed: #blank)
]

{ #category : 'accessing' }
OPPaletteEntry >> palette [
	^ self owner
]

{ #category : 'private' }
OPPaletteEntry >> registerShortcut: newShortcut [

	| receiver |
	receiver := self window.
	(receiver isNil or: [ newShortcut isNil ]) ifTrue: [ ^ self ].

	"SpButtonPresenter binds the shortcut to the Window which means that it will consume any character, which is rather useless when you want to type in a text box. So I selectively check whats the actual target (which is also misreported afaik -_-) and cancel the handling if needed."
	receiver presenter
		bindKeyCombination: newShortcut
		toAction: [ :target :morph :event | 
			(self shouldIgnoreEvent: receiver)
				ifTrue: [ event wasHandled: false ]
				ifFalse: [ self performAction ] ]
]

{ #category : 'protocol' }
OPPaletteEntry >> select [
	tool select.
	self state: true
]

{ #category : 'asserting' }
OPPaletteEntry >> shouldIgnoreEvent: aWindow [

	| writeablePresenters |
	writeablePresenters := { 
		                       SpAbstractTextPresenter.
		                       SpDropListPresenter }.

	aWindow presenter focusedEditor form focusOrder do: [ :each | 
		(writeablePresenters anySatisfy: [ :presenterType | 
			 each isKindOf: presenterType ]) and: [ 
			each withAdapterDo: [ :itemAdapter | 
				itemAdapter widgetDo: [ :itemWidget | 
					itemWidget hasKeyboardFocus ifTrue: [ ^ true ] ] ] ] ].
	^ false
]

{ #category : 'accessing' }
OPPaletteEntry >> tool [
	^ tool
]

{ #category : 'accessing' }
OPPaletteEntry >> tool: aTool [
	tool := aTool
]

{ #category : 'tool api' }
OPPaletteEntry >> whenCreated: aOneArgBlock [
	tool whenCreated: aOneArgBlock
]

{ #category : 'tool api' }
OPPaletteEntry >> whenCreatedSetup [

	self whenCreated: [ :ctrl | 
		OPInitialSetElementCommand executeOn: ctrl ]
]
