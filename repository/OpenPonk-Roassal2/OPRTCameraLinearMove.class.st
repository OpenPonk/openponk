Class {
	#name : #OPRTCameraLinearMove,
	#superclass : #RTLinearMove,
	#category : #'OpenPonk-Roassal2-Animation'
}

{ #category : #refreshing }
OPRTCameraLinearMove >> refresh [
	element translateTo: animatedValue value.
]

{ #category : #public }
OPRTCameraLinearMove >> to: anEndPoint during: seconds on: anElement [
	| position |
	element := anElement.
	
	position := anElement position.
	animatedValue := TRVIAnimatedValue new
							evaluator: [ :t | position interpolateTo: anEndPoint at: (t sqrt) ];
							timer: (TRVITimer new cycleLength: seconds);
							yourself.
	
]
