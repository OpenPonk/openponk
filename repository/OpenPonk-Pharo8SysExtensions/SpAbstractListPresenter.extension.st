Extension { #name : #SpAbstractListPresenter }

{ #category : #'*OpenPonk-Pharo8SysExtensions' }
SpAbstractListPresenter >> whenSelectedDo: aBlock [
	"Inform when an item was selected (a real object in the items list).
	 `aBlock` receives one argument (the new selected element)"

	self
		whenSelectionChangedDo:
			[ :selection | selection selectedItem ifNotNil: [ :item | aBlock value: item ] ]
]
