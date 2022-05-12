Class {
	#name : #MMExample,
	#superclass : #Object,
	#category : #'Mattia-Visualization'
}

{ #category : #'as yet unclassified' }
MMExample >> guice [
	<script: 'self new guice inspect'>
	
	| m |
	m := MModel new.
	m importFromFilename: '/Users/alexandrebergel/Dropbox/GitRepos/VisualizingClassHierarchies/data/guice-broken.json'.
	^ m
]
