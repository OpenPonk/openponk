"
I override my parent so a user can specify the width of the action list.
"
Class {
	#name : #OPGLMMorphicActionListRenderer,
	#superclass : #GLMMorphicActionListRenderer,
	#category : 'OpenPonk-UI-Glamour'
}

{ #category : #private }
OPGLMMorphicActionListRenderer >> buttonMorph: aModel [
	^ (super buttonMorph: aModel)
		icon: aModel glamourAction icon;
		label: aModel buttonLabel;
		yourself
]

{ #category : #rendering }
OPGLMMorphicActionListRenderer >> morphFrom: anActionListPresentation [
	| buttonsContainer buttonModel button |
	buttonsContainer := self rectangleMorphFrom: anActionListPresentation.
	anActionListPresentation allActions
		do: [ :each | 
			buttonModel := GLMButtonModel new.
			buttonModel glamourPresentation: anActionListPresentation.
			buttonModel glamourAction: each.
			button := self buttonMorph: buttonModel.
			buttonsContainer addMorphBack: button.
			button width: (anActionListPresentation width ifNil: [ self class defaultWidth ]) ].
	^ buttonsContainer
]
