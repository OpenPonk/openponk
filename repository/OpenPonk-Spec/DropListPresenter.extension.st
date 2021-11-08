Extension { #name : #DropListPresenter }

{ #category : #'*OpenPonk-Spec' }
DropListPresenter >> addAndSelectItemLabeled: aString do: aBlock [

	"Select the item. If it was not in the list, add it first - silently"

	(self listItems includes: aString) ifFalse: [ 
		self addSilentlyItemLabeled: aString do: aBlock ].
	self setSelectedItem: aString
]

{ #category : #'*OpenPonk-Spec' }
DropListPresenter >> addSilentlyItemLabeled: aString do: aBlock [

	| item |
	item := DropListItem named: aString do: aBlock.
	
	"If you add directly in the contents, the update is not triggered from the value holder"
	listHolder value add: item.
]
