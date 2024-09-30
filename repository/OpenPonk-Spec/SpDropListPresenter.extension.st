Extension { #name : 'SpDropListPresenter' }

{ #category : '*OpenPonk-Spec' }
SpDropListPresenter >> addAndSelectItemLabeled: aString do: aBlock [

	"Select the item. If it was not in the list, add it first - silently"

	(self listItems includes: aString) ifFalse: [ 
		self addSilentlyItemLabeled: aString do: aBlock ].
	self selectItem: aString
]

{ #category : '*OpenPonk-Spec' }
SpDropListPresenter >> addSilentlyItemLabeled: aString do: aBlock [

	| item |
	item := SpDropListItem
		        on: aString
		        do: aBlock.

	model add: item
]
