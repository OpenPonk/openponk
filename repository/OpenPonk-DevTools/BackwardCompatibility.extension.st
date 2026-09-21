Extension { #name : 'BackwardCompatibility' }

{ #category : '*OpenPonk-DevTools' }
BackwardCompatibility class >> reset [
	<script>
	log := nil.
	raiseWarning := nil.
	showWarning := nil.
	active := nil
]
