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
  a.appStart( '.agree dst:./!master src:../repo#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );
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
  a.appStart( '.agree dst:./!master src:\'https://github.com/Wandalen/wModuleForTesting2!master\'' );
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
    test.identical( _.strCount( op.output, /Merge branch \'master\' of https.*\/wModuleForTesting2 into master/ ), 1 );
    return null;
  });

  /* */

  begin();
  a.ready.then( () =>
  {
    test.case = 'agree with local repository, use commit to agree with';
    return null;
  });
  a.appStart( '.agree dst:./!master src:\'https://github.com/Wandalen/wModuleForTesting2#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd\'' );
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

function migrate( test )
{
  const a = test.assetFor( false );
  const dstRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting1.git';
  const dstCommit = '8e2aa80ca350f3c45215abafa07a4f2cd320342a';
  const srcRepositoryRemote = 'https://github.com/Wandalen/wModuleForTesting2.git';

  /* - */

  begin();
  a.ready.then( () =>
  {
    test.case = 'migrate with local repository, start commit';
    return null;
  });
  a.appStart( '.agree dst:./!master src:../repo#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );

  a.appStart( '.migrate dst:./!master src:../repo!master srcState1:#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' )
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

  begin();
  a.ready.then( () =>
  {
    test.case = 'migrate with local repository, start and end commits';
    return null;
  });
  a.appStart( '.agree dst:./!master src:../repo#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd' );

  a.appStart( '.migrate dst:./!master src:../repo!master srcState1:#f68a59ec46b14b1f19b1e3e660e924b9f1f674dd srcState2:#d8c18d24c1d65fab1af6b8d676bba578b58bfad5' )
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
    migrate,
  },
};

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
