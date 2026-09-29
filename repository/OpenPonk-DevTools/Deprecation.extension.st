Extension { #name : 'Deprecation' }

{ #category : '*OpenPonk-DevTools' }
Deprecation class >> reset [
	<script>
	log := nil.
	raiseWarning := nil.
	showWarning := nil.
	active := nil
]
