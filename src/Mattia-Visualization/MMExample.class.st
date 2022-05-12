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

{ #category : #'as yet unclassified' }
MMExample >> p2ToyProject [
	<script: 'self new p2ToyProject inspect'>
	
	| m |
	m := MModel new.
	m importFromFilename: '/Users/alexandrebergel/Dropbox/GitRepos/VisualizingClassHierarchies/data/p2_toy_project.json'.
	^ m
]
