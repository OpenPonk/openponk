Extension { #name : #AbstractWidgetModel }

{ #category : #'*OpenPonk-Spec' }
AbstractWidgetModel >> eventKeyStrokesForNextFocus [
	"String describing the keystroke to perform to jump to the next widget"
	
	^ { Character tab asKeyCombination}
]

{ #category : #'*OpenPonk-Spec' }
AbstractWidgetModel >> eventKeyStrokesForPreviousFocus [
	"String describing the keystroke to perform to jump to the next widget"
	
	^ { Character tab shift asKeyCombination}
]
