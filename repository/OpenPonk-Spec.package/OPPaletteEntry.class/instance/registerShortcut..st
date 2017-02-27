private
registerShortcut: newShortcut
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
			receiver model formModel focusOrder
				detect: [ :each | each widget widget hasKeyboardFocus ]
				ifFound: [ :each | 
					(each isKindOf: TextModel)
						ifTrue: [ shouldIgnoreEvent := true ] ].
			shouldIgnoreEvent
				ifTrue: [ event wasHandled: false ]
				ifFalse: [ self performAction ] ]