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
