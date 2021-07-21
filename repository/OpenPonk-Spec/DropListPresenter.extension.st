Extension { #name : #DropListPresenter }

{ #category : #'*OpenPonk-Spec' }
DropListPresenter >> addSilentlyItemLabeled: aString do: aBlock [

	| item |
	item := DropListItem named: aString do: aBlock.
	
	"If you add directly in the contents, the update is not triggered from the value holder"
	listHolder value add: item.
]
