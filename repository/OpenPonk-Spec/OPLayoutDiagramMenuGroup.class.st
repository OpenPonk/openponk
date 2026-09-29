"
Commander menu group that aggregates all available layout algorithm commands applicable to the currently active diagram.
"
Class {
	#name : 'OPLayoutDiagramMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Layouting',
	#package : 'OpenPonk-Spec',
	#tag : 'Layouting'
}

{ #category : 'accessing' }
OPLayoutDiagramMenuGroup >> icon [
	^ OPIdeaGraphIcons layoutIcon
]

{ #category : 'accessing' }
OPLayoutDiagramMenuGroup >> name [
	^ 'Layout'
]

{ #category : 'accessing' }
OPLayoutDiagramMenuGroup >> order [
	^ 200
]
