Class {
	#name : #OPTRAbstractDoubleArrowHeadShape,
	#superclass : #TRAbstractLineDecoratorShape,
	#category : #'OpenPonk-Trachel-Shapes'
}

{ #category : #visitor }
OPTRAbstractDoubleArrowHeadShape >> accept: aVisitor onStart: aBoolean [

	aVisitor visitDoubleArrowHeadShape: self onStart: aBoolean
]
