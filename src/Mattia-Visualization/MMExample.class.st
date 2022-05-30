Class {
	#name : #MMExample,
	#superclass : #Object,
	#category : #'Mattia-Visualization'
}

{ #category : #examples }
MMExample >> framework [
	<script: 'self new framework inspect'>
	
	| m |
	m := MModel new.
	m importFromFilename: self path, 'framework.json'.
	^ m
]

{ #category : #examples }
MMExample >> guava [
	<script: 'self new guava inspect'>
	
	| m |
	m := MModel new.
	m importFromFilename: self path, 'guava.json'.
	^ m
]

{ #category : #examples }
MMExample >> guice [
	<script: 'self new guice inspect'>
	
	| m |
	m := MModel new.
	m importFromFilename: self path, 'guice.json'.
	^ m
]

{ #category : #examples }
MMExample >> hadoop [
	<script: 'self new hadoop inspect'>
	
	| m |
	m := MModel new.
	m importFromFilename: self path, 'hadoop.json'.
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
