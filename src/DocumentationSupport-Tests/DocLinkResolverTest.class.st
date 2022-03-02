Class {
	#name : #DocLinkResolverTest,
	#superclass : #TestCase,
	#instVars : [
		'resolver'
	],
	#category : #'DocumentationSupport-Tests'
}

{ #category : #running }
DocLinkResolverTest >> setUp [
	super setUp.
	
	resolver := DocLinkResolver
]

{ #category : #tests }
DocLinkResolverTest >> testIsValidAddressForName [
	self assert: (resolver isValidAddressForName: 'pharo.org' timeout: 60)
]

{ #category : #tests }
DocLinkResolverTest >> testIsValidAddressForNameWithNotValidAddress [
	self assert: (resolver isValidAddressForName: 'pharo?zdds.org' timeout: 60) not
]

{ #category : #tests }
DocLinkResolverTest >> testIsValidChapterForName [
	| chapter |
	chapter := DocChapter new.
	DocChapter addDictionaryOfChapters: chapter.
	self assert: (resolver isValidChapterForName: chapter key).
	DocChapter removeDictionaryOfChapters: chapter.
]

{ #category : #tests }
DocLinkResolverTest >> testIsValidChapterForNameWithNotValidKey [
	| chapter |
	chapter := DocChapter new.
	DocChapter addDictionaryOfChapters: chapter.
	self assert: (resolver isValidChapterForName: chapter key, 'pharo') not.
	DocChapter removeDictionaryOfChapters: chapter.
]
