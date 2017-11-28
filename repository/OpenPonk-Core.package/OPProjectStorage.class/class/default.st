accessing
default
	<script: 'self default inspect'>
	^ Default ifNil: [ Default := self new ]