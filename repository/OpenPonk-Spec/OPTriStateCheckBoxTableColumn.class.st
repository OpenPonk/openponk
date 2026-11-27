"
Table column definition rendering a clickable tri-state checkbox supporting #checked, #partial, and #unchecked states. Evaluates each row item to one of those three symbols and dispatches clicks from #unchecked or #partial to onActivation and from #checked to onDeactivation.
"
Class {
	#name : 'OPTriStateCheckBoxTableColumn',
	#superclass : 'SpTableColumn',
	#instVars : [
		'onActivation',
		'onDeactivation'
	],
	#category : 'OpenPonk-Spec-Widgets',
	#package : 'OpenPonk-Spec',
	#tag : 'Widgets'
}

{ #category : 'visiting' }
OPTriStateCheckBoxTableColumn >> acceptColumnVisitor: aBuilder [

	^ aBuilder visitTriStateCheckboxColumn: self
]

{ #category : 'events' }
OPTriStateCheckBoxTableColumn >> handleClickFor: anItem state: aState [

	aState = #checked ifTrue: [
			onDeactivation ifNotNil: [ :valuable | valuable cull: anItem ].
			^ self ].
	(#( #partial #unchecked ) includes: aState) ifTrue: [
			onActivation ifNotNil: [ :valuable | valuable cull: anItem ].
			^ self ].
	self error: 'Unsupported tri-state checkbox state: ' , aState printString
]

{ #category : 'accessing' }
OPTriStateCheckBoxTableColumn >> iconNameForState: aState [

	aState = #checked ifTrue: [ ^ #checkedBox ].
	aState = #partial ifTrue: [ ^ #partialCheckedBox ].
	aState = #unchecked ifTrue: [ ^ #uncheckedBox ].
	self error: 'Unsupported tri-state checkbox state: ' , aState printString
]

{ #category : 'api' }
OPTriStateCheckBoxTableColumn >> onActivation [

	^ onActivation
]

{ #category : 'api' }
OPTriStateCheckBoxTableColumn >> onActivation: aBlock [

	onActivation := aBlock
]

{ #category : 'api' }
OPTriStateCheckBoxTableColumn >> onDeactivation [

	^ onDeactivation
]

{ #category : 'api' }
OPTriStateCheckBoxTableColumn >> onDeactivation: aBlock [

	onDeactivation := aBlock
]
