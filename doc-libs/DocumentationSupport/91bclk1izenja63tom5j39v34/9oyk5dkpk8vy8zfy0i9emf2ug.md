title: Libraries
key: 9oyk5dkpk8vy8zfy0i9emf2ug
parent: 9oyk5dgkepkaexj58cjea76jk
nextChapter: 3z9zm765drcfzotsq9dvc48d4

# Libraries

Libraries are stored using repositories.  A project is supposed to define somewhere, most usually in a Baseline, the repository. A baseline is supposed to contain a method with pragma `documentationRepository` that returns an instance of   `DocLibraryRepository`. This repository instance then can return a collection of libraries.

See `BaselineOfDocumaps class>>#documentationRepository` to see an example of such repository definition.

The other responsibility of the library repository is to be able to store a given library in the repository. When a library is loaded from the repository, it remembers it so it can be easily saved back into the repository when it is modified.

The libraries are, independently on the repository, saved in a global dictionary in the  `DocLibrary` class. This dictionary is generated lazily. When it is first used, the methods with pragma  `documentationRepository` are collected, and this dictionary is filled with libraries defined by these repositories.  

The method `DocLibrary class>>#clearLibraries` resets this global dictionary, so it returns all the libraries to the last saved state. This means that **you may loose your unsaved changes**!

To open GUI for the library evaluate:
```
DocLibraryPresenter open: #DocumentationSupport.
```
where #Documaps is the library name



