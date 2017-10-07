as yet unclassified
editExample
	<script>
	| page playground |
	(page := GTPlayPage new) saveContent: (((self class >> #sampleExampleEdit) sourceCode lines allButFirst: 2) joinUsing: String cr).
	(playground := GTPlayground new) openOn: page