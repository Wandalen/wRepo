## How to use command interface

The cheat sheet how to use commands.

To get help about command type

```bash
repo .help [command]
```

`command` should have not first dot.

### `.agree`

Command restriction :

- `dst` repository should be a local repository;
- `dst` repository path should have branch;
- `src` repository path should have some defined state - branch, tag, commit.

Examples :

- To agree another repository :

```bash
repo .agree dst:[repo][!branch] src:[repo][state]
```
If run command from destination repository and source repository is `https://github.com/test/test.git`, then command looks like :

```bash
repo .agree dst:'./!master' src:'https://github.com/test/test.git/!master'
```

- To set agree message, use option `message` :

```bash
repo .agree dst:[repo][!branch] src:[repo][state] message:'sync'
```
Agree commit will have message `sync`.

- To include files with specific paths use option `only` :

```bash
repo .agree dst:[repo][!branch] src:[repo][state] only:'**/*.js'
repo .agree dst:[repo][!branch] src:[repo][state] only:'**/*.js' only:'Readme.md'
repo .agree dst:[repo][!branch] src:[repo][state] only:'[**/*.js, Readme.md]'
```
Option `only` accepts strings with globs.

First command selects all files with extension `js`. Second and third command declare vectorized form of option `only`, commands select all files with extension `js` and file `Readme.md`.

- To exclude files with specific paths use option `but` :

```bash
repo .agree dst:[repo][!branch] src:[repo][state] but:'**/*.js'
repo .agree dst:[repo][!branch] src:[repo][state] but:'**/*.js' but:'Readme.md'
repo .agree dst:[repo][!branch] src:[repo][state] but:'[**/*.js, Readme.md]'
```
Option `but` accepts strings with globs.

First command excludes all files with extension `js`. Second and third command declare vectorized form of option `but`, commands exclude all files with extension `js` and file `Readme.md`.

Options `but` and `only` can be combined to select files.

Option `but` can exclude files selected by option `only`.

- To get files from specific source repository directory use option `srcDirPath` :

```bash
repo .agree dst:[repo][!branch] src:[repo][state] srcDirPath:'target'
```
Option `srcDirPath` accepts no globs.

Command will select files from directory `target`.

- To put files to specific destination repository directory use option `dstDirPath` :

```bash
repo .agree dst:[repo][!branch] src:[repo][state] dstDirPath:'build'
```
Option `dstDirPath` accepts no globs.

Command will put files to directory `build`.

### `.migrate`

Command restriction :

- `dst` repository should be a local repository;
- `dst` repository path should have branch;
- `src` repository path should have branch;
- state `srcState1` should be defined;
- current state of destination repository should be synchronized with `srcState1`.

Examples :

- To migrate all commits from state `srcState1` :

```bash
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state]
```
If run command from destination repository, source repository is `https://github.com/test/test.git` and `srcState1` is `2e519325b8643b54197fc5abdc4a600060589c64`, then command looks like :

```bash
repo .migrate dst:'./!master' src:'https://github.com/test/test.git/!master' srcState1:'#2e519325b8643b54197fc5abdc4a600060589c64'
```

- To migrate range of commits from state `srcState1` to state `srcState2` :

```bash
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state] srcState2:[state]
```

- To include files with specific paths use option `only` :

```bash
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state] only:'**/*.js'
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state] only:'**/*.js' only:'Readme.md'
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state] only:'[**/*.js, Readme.md]'
```
Option `only` accepts strings with globs.

First command selects all commits, which modify files with extension `js`. Second and third command declare vectorized form of option `only`, commands select all commits, which modify files with extension `js` and file `Readme.md`.

- To exclude files with specific paths use option `but` :

```bash
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state] but:'**/*.js'
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state] but:'**/*.js' but:'Readme.md'
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state] but:'[**/*.js, Readme.md]'
```
Option `but` accepts strings with globs.

First command selects all commits, which modify no files with extension `js`. Second and third command declare vectorized form of option `but`, commands select all commits, which modify no files with extension `js` and file `Readme.md`.

Options `but` and `only` can be combined to select files.

Option `but` can exclude files selected by option `only`.

- To get files from specific source repository directory use option `srcDirPath` :

```bash
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state] srcDirPath:'target'
```
Option `srcDirPath` accepts no globs.

Command will select files from directory `target`.

- To put files to specific destination repository directory use option `dstDirPath` :

```bash
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state] dstDirPath:'build'
```
Option `dstDirPath` accepts no globs.

Command will put files to directory `build`.

- To modify commit author dates use option `onDate` or set of options `relative`, `delta`, `periodic` and `deviation`.

Option `onDate` accepts path to hook to change date.

Example of callback which returns original date :

```js
function onDate( date )
{
  return date;
}
module.exports = onDate;
```
Parameter `date` is a string in format `YYYY-MM-DD HH:MM:SS +XXXX`, where `+XXXX` is timezone.

Command to change date by hook :

```bash
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state] onDate:'./OnDate.js'
```

Set of options `relative`, `delta`, `periodic` and `deviation` can construct callback to change date. To get textual help about option input :

```
repo .help migrate
```

Combinations and results :

- `relative:'commit' delta:'00:00:00'` -> change no date of commits;
- `relative:'commit' delta:'01:00:00'` -> will add one hour to each commit date;
- `relative:'commit' delta:'-01:00:00'` -> will decrease each commit date by one hour;
- `relative:'now' delta:'00:00:00'` -> applies current date ( moment of committing ) to each commit;
- `relative:'now' delta:'01:00:00'` -> applies current date increased by one hour to each commit;
- `relative:'now' delta:'-01:00:00'` -> applies current date decreased by one hour to each commit;
- `relative:'commit' delta:'24:00:00' periodic:'01:00:00'` -> to first commit date will be added one day, next commits will be committed with period one hour;
- `relative:'now' delta:'-24:00:00' periodic:'01:00:00'` -> first commit in range will have date === current date  minus one day, next commits will be committed with period one hour;
- `relative:'commit' delta:'24:00:00' periodic:'01:00:00' deviation:'00:30:00'` -> to first commit date will be added one day, next commits will be committed with period one hour +-15 minutes;
- `relative:'now' delta:'-24:00:00' periodic:'01:00:00' deviation:'00:30:00'` -> first commit in range will have date === current date  minus one day, next commits will be committed with period one hour;

Full command :

```bash
repo .migrate dst:[repo][!branch] src:[repo][!branch] srcState1:[state] relative:[now|commit] delta:[time] periodic:[time] deviation:[time]
```

### `.commits.dates`

Command restriction :

- repository should be a local repository;
- state `state1` should be defined;
- to change date at least option `delta` should be non zero.

Examples :

- To change all commits dates in current branch from state `state1` :

```bash
repo .commits.dates dst:[repo] state1:[state] delta:[time]
```

- To change range of commits dates in current branch from state `state1` to state `state2` :

```bash
repo .commits.dates dst:[repo] state1:[state] state2:[state] delta:[time]
```

Set of options `relative`, `delta`, `periodic` and `deviation` can construct callback to change date. To get textual help about option input :

```
repo .help commits.dates
```

Combinations and results :

- `relative:'commit' delta:'00:00:00'` -> change no date of commits;
- `relative:'commit' delta:'01:00:00'` -> will add one hour to each commit date;
- `relative:'commit' delta:'-01:00:00'` -> will decrease each commit date by one hour;
- `relative:'now' delta:'00:00:00'` -> applies current date ( moment of committing ) to each commit;
- `relative:'now' delta:'01:00:00'` -> applies current date increased by one hour to each commit;
- `relative:'now' delta:'-01:00:00'` -> applies current date decreased by one hour to each commit;
- `relative:'commit' delta:'24:00:00' periodic:'01:00:00'` -> to first commit date will be added one day, next commits will be committed with period one hour;
- `relative:'now' delta:'-24:00:00' periodic:'01:00:00'` -> first commit in range will have date === current date  minus one day, next commits will be committed with period one hour;
- `relative:'commit' delta:'24:00:00' periodic:'01:00:00' deviation:'00:30:00'` -> to first commit date will be added one day, next commits will be committed with period one hour +-15 minutes;
- `relative:'now' delta:'-24:00:00' periodic:'01:00:00' deviation:'00:30:00'` -> first commit in range will have date === current date  minus one day, next commits will be committed with period one hour;

Full command :

```bash
repo .commits.dates dst:[repo] state1:[state] relative:[now|commit] delta:[time] periodic:[time] deviation:[time]
```

