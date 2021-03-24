title: Export
key: 3z9zm74a6w6vnk79244tykdrk
parent: 91bclk1izenja63tom5j39v34
nextChapter: 3z9zm795f0wjg34wm5gruk4ns

# Export

To export a library to store it in the `STON` based format on the disk, press the _Export_ button in the Library editor. 

Currently, Iceberg does not have proper support for external files, so you need to commit the exported files manually:
- Press the `Export`button in the documentation GUI
- Commit all your non-documentation changes
- Go the _Toobar - Documaps - 4) Open external Git shell"_
- in the Git window, do 
```
git add *
git commit -a
```
- close the Git window
- Go the _Toobar - Documaps - 5) Synchronize image working copy_
- confirm the dialog by pressing _Checkout_ 

