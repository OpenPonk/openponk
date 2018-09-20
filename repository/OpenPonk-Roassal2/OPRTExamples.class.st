"
I contain some examples for shapes and utilities available in this package.
"
Class {
	#name : #OPRTExamples,
	#superclass : #RTAbstractExample,
	#category : 'OpenPonk-Roassal2-Examples'
}

{ #category : #'as yet unclassified' }
OPRTExamples class >> editExample [
	<script>
	| page playground |
	(page := GTPlayPage new) saveContent: (((self class >> #sampleExampleEdit) sourceCode lines allButFirst: 2) joinUsing: String cr).
	(playground := GTPlayground new) openOn: page
]

{ #category : #'instance creation' }
OPRTExamples class >> open [
	<script>
	self new inspect
]

{ #category : #'as yet unclassified' }
OPRTExamples class >> sampleExampleEdit [
| page playground |
(page := GTPlayPage new)
	saveContent: '|v|
v := RTView new.

^ v'.
(playground := GTPlayground new)
	openOn: page.

OPRTExamples new installTitle: 'label' capitalized code: page content.

page saveContent: 'new content'.
playground update.
]

{ #category : #sources }
OPRTExamples >> exampleAdornments [
|v el|
v := RTView new.

el := RTBox new
	size: 100;
	element.
v add: el.
el
	@
		(OPRTAdornments new
			adornments:
				{#testNotRun asIcon
					-> [ el color: Color veryVeryLightGray.
						v signalUpdate ].
				#testGreen asIcon
					-> [ el color: Color green.
						v signalUpdate ].
				#testRed asIcon
					-> [ el color: Color red.
						v signalUpdate ]}).
el when: TRMouseLeftClick do: [ :evt | el announce: OPTRFocused new ].
v when: TRMouseLeftClick do: [ :evt | el announce: OPTRUnfocused new ].

^ v
]

{ #category : #icons }
OPRTExamples >> exampleAdornmentsIcon [
	^ 'iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAABHklEQVR4XuXasREAIAgEQUuj
/yboBLUGJXDc4FICNv0REdPvnYb/BB/EzwfxQfx8EB/EzwfxQfx8EB/Ef4QP4ueD+CB+PogP
4ueD+CB+PogP4ueD+PkgPoifD+KD+PkgPoifD+KD+Pkgfj6ID+Lng/ggfj6ID+Lng/ggfj6I
nw/ig1yVma3tm+WD+CA+iA/ig/ggPogP4oP4ID6ID+KD+CA+iA/ig/ggPogP4oP4ID6ID+KD
+CA+iA/ig/ggn4wcqjl/5ODng/ggfj6ID+Lng/ggfj6Inw/ig/j5ID6Inw/ig/j5ID6Inw/i
54P4IH4+iA/i54P4IH4+iA/i54P4+SA+iJ8P4oP4+SA+iJ8P4oP4+SB+PogP4ueD+CB+5y0I
CSJCdIuZAgAAAABJRU5ErkJggg=='
]

{ #category : #accessing }
OPRTExamples >> label [
	^ 'OpenPonk Extensions'
]
