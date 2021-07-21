Extension { #name : #AbstractWidgetPresenter }

{ #category : #'*OpenPonk-Spec' }
AbstractWidgetPresenter >> eventKeyStrokesForNextFocus [
	"String describing the keystroke to perform to jump to the next widget"
	
	^ { Character tab asKeyCombination}
]

{ #category : #'*OpenPonk-Spec' }
AbstractWidgetPresenter >> eventKeyStrokesForPreviousFocus [
	"String describing the keystroke to perform to jump to the next widget"
	
	^ { Character tab shift asKeyCombination}
]
