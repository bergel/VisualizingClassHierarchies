Class {
	#name : #MMExample,
	#superclass : #Object,
	#category : #'Mattia-Visualization'
}

{ #category : #examples }
MMExample >> guice [
	<script: 'self new guice inspect'>
	
	| m |
	m := MModel new.
	m importFromFilename: self path, 'guice.json'.
	^ m
]

{ #category : #examples }
MMExample >> p2ToyProject [
	<script: 'self new p2ToyProject inspect'>
	
	| m |
	m := MModel new.
	m importFromFilename: self path, 'p2_toy_project.json'.
	^ m
]

{ #category : #examples }
MMExample >> path [
	^ '/Users/alexandrebergel/Dropbox/GitRepos/VisualizingClassHierarchies/data/'
]
