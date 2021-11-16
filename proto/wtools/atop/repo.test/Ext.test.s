( function _Ext_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  require( '../repo/entry/Include.s' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

// --
// context
// --

function onSuiteBegin()
{
  let context = this;
  context.suiteTempPath = __.path.tempOpen( __.path.join( __dirname, '../..' ), 'repo' );
  context.appJsPath = __.path.join( __dirname, '../repo/entry/Exec' );
}

//

function onSuiteEnd()
{
  let context = this;
  __.assert( __.strHas( context.suiteTempPath, '/repo' ) )
  __.path.tempClose( context.suiteTempPath );
}

// --
// tests
// --

function agree( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const srcState = 'f68a59ec46b14b1f19b1e3e660e924b9f1f674dd';

  /* - */

  begin();
  a.ready.then( () =>
  {
    test.case = 'agree with local repository, use master branch to agree with';
    return null;
  });
  a.appStart( '.agree dst:./!master src:../repo!master' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /Merge branch \'master\' of .*\/repo into master/ ), 1 );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'agree with local repository, use commit to agree with';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState }` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /Merge branch \'master\' of .*\/repo.* into master/ ), 1 );
    return null;
  });

  /* - */

  begin();
  a.ready.then( () =>
  {
    test.case = 'agree with remote repository, use master branch to agree with';
    return null;
  });
  a.appStart( `.agree dst:./!master src:'${ srcRepositoryRemote }'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    console.log( op.output );
    test.identical( _.strCount( op.output, /Merge branch \'master\' of https.*\/wModuleForTesting2.* into master/ ), 1 );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'agree with local repository, use commit to agree with';
    return null;
  });
  a.appStart( `.agree dst:./!master src:\`${ srcRepositoryRemote }#${ srcState }\`` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, /Merge branch \'master\' of https.*\/wModuleForTesting2.* into master/ ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '../repo' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    return a.shell( `git clone ${ srcRepositoryRemote } ../repo` );
  }
}

//

function agreeWithOptionMessage( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const srcState = 'f68a59ec46b14b1f19b1e3e660e924b9f1f674dd';

  /* - */

  begin();
  a.ready.then( () =>
  {
    test.case = 'agree with local repository, use commit to agree with';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState } message:'Sync repositories'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });
  a.shell( 'git log -n 1' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Sync repositories' ), 1 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '../repo' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    return a.shell( `git clone ${ srcRepositoryRemote } ../repo` );
  }
}

//

function agreeWithOptionBut( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const srcState = 'f68a59ec46b14b1f19b1e3e660e924b9f1f674dd';

  /* - */

  begin();
  a.ready.then( () =>
  {
    test.case = 'no option but';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState }` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 14 );
    test.true( _.longHasAll( files, [ 'will.yml', 'package.json', 'was.package.json' ] ) );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'but - string, matches file, exclude single file';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState } but:'package.json'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 13 );
    test.true( _.longHasAll( files, [ 'will.yml', 'was.package.json' ] ) );
    test.false( _.longHas( files, 'package.json' ) );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'but - string, no matching, exclude no file';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState } but:'unknown.json'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 14 );
    test.true( _.longHasAll( files, [ 'will.yml', 'package.json', 'was.package.json' ] ) );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'but - string with glob, matches files, exclude two files';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState } but:'*package.json'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    return null;
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 12 );
    test.true( _.longHas( files, 'will.yml' ) );
    test.false( _.longHasAny( files, [ 'package.json', 'was.package.json' ] ) );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'but - several strings in array, matches files, exclude two files';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState } but:'*package.json' but:'will.yml' but:'unknown.json'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    return null;
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 11 );
    test.false( _.longHasAny( files, [ 'will.yml', 'package.json', 'was.package.json' ] ) );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'but - several strings in array, matches files, exclude two files';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState } but:'[*package.json, will.yml, unknown.json]'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    return null;
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 11 );
    test.false( _.longHasAny( files, [ 'will.yml', 'package.json', 'was.package.json' ] ) );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '../repo' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    return a.shell( `git clone ${ srcRepositoryRemote } ../repo` );
  }
}

agreeWithOptionBut.timeOut = 180000;

//

function agreeWithOptionOnly( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const srcState = 'f68a59ec46b14b1f19b1e3e660e924b9f1f674dd';

  /* - */

  begin();
  a.ready.then( () =>
  {
    test.case = 'no option only';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState }` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 14 );
    test.true( _.longHasAll( files, [ 'will.yml', 'package.json', 'was.package.json' ] ) );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'only - string, matches file, include single file';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState } only:'package.json'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    return null;
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 1 );
    test.identical( files, [ 'package.json' ] );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'only - string, no matching, include no file';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState } only:'unknown.json'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting1' );
    test.identical( config.version, '0.0.186' );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'only - string with glob, matches files, include two files';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState } only:'*package.json'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 2 );
    test.identical( files, [ 'package.json', 'was.package.json' ] );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'only - several strings in array, matches files, exclude two files';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState } only:'*package.json' only:'will.yml' only:'unknown.json'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 3 );
    test.identical( files, [ 'package.json', 'was.package.json', 'will.yml' ] );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'only - several strings in array, matches files, exclude two files';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState } only:'[*package.json, will.yml, unknown.json]'` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.170' );
    return null;
  });
  a.shell( 'git diff --name-only HEAD~..HEAD' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var files = op.output.trim().split( '\n' );
    test.identical( files.length, 3 );
    test.identical( files, [ 'package.json', 'was.package.json', 'will.yml' ] );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '../repo' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    return a.shell( `git clone ${ srcRepositoryRemote } ../repo` );
  }
}

agreeWithOptionOnly.timeOut = 180000;

//

function migrate( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';
  const srcState1 = 'f68a59ec46b14b1f19b1e3e660e924b9f1f674dd';
  const srcState2 = 'd8c18d24c1d65fab1af6b8d676bba578b58bfad5';

  /* - */

  begin();
  a.ready.then( () =>
  {
    test.case = 'migrate with local repository, start commit';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState1 }` );

  a.appStart( `.migrate dst:./!master src:../repo!master srcState1:#${ srcState1 }` )
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'migrate with local repository, start and end commits';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState1 }` );

  a.appStart( `.migrate dst:./!master src:../repo!master srcState1:#${ srcState1 } srcState2:#${ srcState2 }` )
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });

  /* - */

  begin();
  a.ready.then( () =>
  {
    test.case = 'migrate with remote repository, start commit';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState1 }` );

  a.appStart( `.migrate dst:./!master src:'${ srcRepositoryRemote }!master' srcState1:#${ srcState1 }` )
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'migrate with local repository, start and end commits';
    return null;
  });
  a.appStart( `.agree dst:./!master src:../repo#${ srcState1 }` );

  a.appStart( `.migrate dst:./!master src:'${ srcRepositoryRemote }!master' srcState1:#${ srcState1 } srcState2:#${ srcState2 }` )
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    var config = a.fileProvider.fileReadUnknown( a.abs( 'was.package.json' ) );
    test.identical( config.name, 'wmodulefortesting2' );
    test.identical( config.version, '0.0.178' );
    return null;
  });
  a.shell( 'git log -n 20' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '../repo' ) ); return null });
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( `git clone ${ dstRepositoryRemote } ./` );
    a.shell( `git reset --hard ${ dstCommit }` );
    return a.shell( `git clone ${ srcRepositoryRemote } ../repo` );
  }
}

// --
// declare
// --

const Proto =
{

  name : 'Tools.Repo.Ext',
  silencing : 1,

  onSuiteBegin,
  onSuiteEnd,
  routineTimeOut : 60000,

  context :
  {
    suiteTempPath : null,
    appJsPath : null,
  },

  tests :
  {
    agree,
    agreeWithOptionMessage,
    agreeWithOptionBut,
    agreeWithOptionOnly,

    migrate,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
