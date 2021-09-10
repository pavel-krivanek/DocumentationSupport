Class {
	#name : #SearchBookTest,
	#superclass : #TestCase,
	#category : #'DocumentationSupport-Search-Tests'
}

{ #category : #tests }
SearchBookTest >> testIndexOfSubstring [
	| searchObject |
	searchObject := SearchBook new.
	self assert: (searchObject indexOfSubstring: 'test' in: 'test other test word') equals: #(1 12) asOrderedCollection
	
]
