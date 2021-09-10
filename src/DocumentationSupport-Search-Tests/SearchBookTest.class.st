Class {
	#name : #SearchBookTest,
	#superclass : #TestCase,
	#category : #'DocumentationSupport-Search-Tests'
}

{ #category : #tests }
SearchBookTest >> testIndexOfChapters [
	| searchObject book |
	searchObject := SearchBook new.
	book := DocBook new.
	book setLibrary: DocLibrary new;
	addNewChapter;
	addNewChapter;
	addNewChapter.
	(book chapters at: 2) title: 'test'.
	self assert: (searchObject indexOfChapters:  'test' in: book ) equals: #(2) asOrderedCollection
	
]

{ #category : #tests }
SearchBookTest >> testIndexOfSubstring [
	| searchObject |
	searchObject := SearchBook new.
	self assert: (searchObject indexOfSubstring: 'test' in: 'test other test word') equals: #(1 12) asOrderedCollection
	
]
