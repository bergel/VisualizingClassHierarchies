Class {
	#name : #MModelTest,
	#superclass : #TestCase,
	#category : #'Mattia-Visualization'
}

{ #category : #tests }
MModelTest >> testEmpty [
	| m |
	m := MModel new.
	self assert: m numberOfClasses equals: 0
]
