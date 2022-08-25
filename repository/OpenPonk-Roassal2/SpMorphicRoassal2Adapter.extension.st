Extension { #name : #SpMorphicRoassal2Adapter }

{ #category : #'*OpenPonk-Roassal2' }
SpMorphicRoassal2Adapter >> basicApplyScript [

	self model script cull: view cull: canvas.

	self widgetDo: #startStepping.
	"view when: TRMouseEnter do: [ widget takeKeyboardFocus ]"
]
