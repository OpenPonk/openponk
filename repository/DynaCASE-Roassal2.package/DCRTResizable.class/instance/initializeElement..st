initialization
initializeElement: anElement
	"postpone initialization if the element is not yet added to the view"
	anElement view
		ifNil: [ anElement addCallback: (TRAddedCallback block: [ :evt | self lazyInitializeElement: anElement ]) ]
		ifNotNil: [ self lazyInitializeElement: anElement ]