"
Spec button presenter representing a single selectable item (tool) inside an OpenPonk palette. Encapsulates an OPPaletteTool (such as a creation or connection tool) and handles its selection state and shortcuts.
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

	| writeablePresenters focusedEditor |
	focusedEditor := aWindow presenter focusedEditor.
	(focusedEditor isNil or: [ focusedEditor ~= self palette editor ]) ifTrue: [ ^ true ].
	writeablePresenters := {
		                       SpAbstractTextPresenter.
		                       SpDropListPresenter }.
	focusedEditor form focusOrder do: [ :each |
			(writeablePresenters anySatisfy: [ :presenterType | each isKindOf: presenterType ]) ifTrue: [
				each withAdapterDo: [ :itemAdapter | itemAdapter widgetDo: [ :itemWidget | itemWidget hasKeyboardFocus ifTrue: [ ^ true ] ] ] ] ].
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
