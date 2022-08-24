Class {
	#name : #MModelTest,
	#superclass : #TestCase,
	#category : #'Mattia-Visualization'
}

{ #category : #tests }
MModelTest >> testEmpty [
	| m |
	m := MProject new.
	self assert: m numberOfClasses equals: 0
]
