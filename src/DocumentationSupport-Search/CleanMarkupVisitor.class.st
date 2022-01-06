Class {
	#name : #CleanMarkupVisitor,
	#superclass : #MicrodownVisitor,
	#instVars : [
		'text'
	],
	#category : #'DocumentationSupport-Search'
}

{ #category : #initialization }
CleanMarkupVisitor >> initialize [
	super initialize.
	text := ''
]

{ #category : #accessing }
CleanMarkupVisitor >> text [
	^ text
]

{ #category : #visiting }
CleanMarkupVisitor >> visit: test [
	super visit: test
]
