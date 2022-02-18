( function _RepoBasic_s_()
{

'use strict';

//

const _global = _global_;
const _ = _global.wTools;

//

/**
 * @class wRepoBasic
 * @module Tools/atop/Repo
 */

const Parent = null;
const Self = wRepoBasic;
function wRepoBasic( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Repo';

// --
// inter
// --

function finit()
{
  return _.Copyable.prototype.finit.apply( this, arguments );
}

//

function init( o )
{
  let repo = this;

  _.assert( arguments.length <= 1 );

  let logger = repo.logger = new _.Logger({ output : _global.logger, name : 'Repo', verbosity : 4 });

  _.workpiece.initFields( repo );
  Object.preventExtensions( repo );

  _.assert( logger === repo.logger );

  if( o )
  repo.copy( o );
}

// --
//
// --

function repositoryAgree( o )
{
  _.routine.options( repositoryAgree, o );

  const currentPath = _.git.path.current();
  const srcProvider  = _.repo.providerForPath( o.src );
  if( srcProvider.name === 'hd' )
  o.src = _.git.path.join( currentPath, o.src );
  o.dst = _.git.path.join( currentPath, o.dst );
  const nativized = _.git.path.nativize( o.dst );

  if( !_.git.isRepository({ localPath : _.git.path.nativize( o.dst ) }) )
  throw _.error.brief( 'Destination path should be a repository. Please, input valid destination path.' )

  const srcParsed = _.git.path.parse( o.src );
  _.sure( srcParsed.tag !== undefined || srcParsed.hash !== undefined );
  if
  (
    srcProvider.name === 'hd'
    && _.git.isRepository({ localPath : _.git.path.nativize( o.src ) })
    && srcParsed.tag === 'master'
    && !_.str.has( o.src, _.git.path.tagToken )
  )
  srcParsed.tag = _.git.tagLocalRetrive({ localPath : o.src });

  const ready = _.take( null ).then( () =>
  {
    return _.git.repositoryAgree
    ({
      srcBasePath : o.src,
      dstBasePath : nativized,
      srcState : srcParsed.tag ? `!${ srcParsed.tag }` : `#${ srcParsed.hash }`,
      srcDirPath : o.srcDirPath,
      dstDirPath : o.dstDirPath,
      commitMessage : o.message,
      mergeStrategy : o.mergeStrategy,
      relative : o.relative,
      delta : o.delta,
      but : o.but,
      only : o.only,
      logger : o.dry ? 2 : o.verbosity,
      dry : o.dry,
    });
  });
  return ready.finally( ( err, arg ) =>
  {
    if( err )
    throw _.error.brief( err );
    return arg;
  });
}

repositoryAgree.defaults =
{
  src : null,
  dst : null,
  srcDirPath : null,
  dstDirPath : null,
  message : null,
  mergeStrategy : null,
  but : null,
  only : null,
  relative : 'commit',
  delta : null,
  verbosity : 1,
  dry : 0,
};

//

function repositoryMigrate( o )
{
  _.routine.options( repositoryMigrate, o );

  const currentPath = _.git.path.current();
  const srcProvider  = _.repo.providerForPath( o.src );
  if( srcProvider.name === 'hd' )
  o.src = _.git.path.join( currentPath, o.src );
  o.dst = _.git.path.join( currentPath, o.dst );
  const nativized = _.git.path.nativize( o.dst );

  if( !_.git.isRepository({ localPath : _.git.path.nativize( o.dst ) }) )
  throw _.error.brief( 'Destination path should be a repository. Please, input valid destination path.' )

  const srcParsed = _.git.path.parse( o.src );
  _.sure( srcParsed.tag !== undefined || srcParsed.hash !== undefined );
  if
  (
    srcProvider.name === 'hd'
    && _.git.isRepository({ localPath : _.git.path.nativize( o.src ) })
    && srcParsed.tag === 'master'
    && !_.str.has( o.src, _.git.path.tagToken )
  )
  srcParsed.tag = _.git.tagLocalRetrive({ localPath : _.git.path.nativize( o.src ) });

  let onCommitMessage = o.onMessage;
  if( onCommitMessage )
  onCommitMessage = require( _.path.nativize( _.path.join( _.path.current(), onCommitMessage ) ) );

  let onDate = o.onDate;
  if( o.onDate === 'construct' )
  {
    onDate = Object.create( null );
    onDate.relative = o.relative;
    onDate.delta = o.delta;
    onDate.periodic = o.periodic;
    onDate.deviation = o.deviation;
  }
  else
  {
    onDate = require( _.path.nativize( _.path.join( _.path.current(), onDate ) ) );
  }

  const ready = _.take( null ).then( () =>
  {
    return _.git.repositoryMigrate
    ({
      srcBasePath : o.src,
      dstBasePath : nativized,
      srcState1 : o.srcState1,
      srcState2 : o.srcState2,
      srcDirPath : o.srcDirPath,
      dstDirPath : o.dstDirPath,
      onCommitMessage,
      onDate,
      but : o.but,
      only : o.only,
      logger : o.dry ? 2 : o.verbosity,
      dry : o.dry,
    });
  });
  return ready.finally( ( err, arg ) =>
  {
    if( err )
    throw _.error.brief( err );
    return arg;
  });
}

repositoryMigrate.defaults =
{
  src : null,
  dst : null,
  srcState1 : null,
  srcState2 : null,
  srcDirPath : null,
  dstDirPath : null,
  but : null,
  only : null,
  onMessage : null,

  onDate : 'construct',
  relative : 'commit',
  delta : 0,
  periodic : 0,
  deviation : 0,

  verbosity : 1,
  dry : 0,
};

//

function commitsDates( o )
{
  _.routine.options( commitsDates, o );

  const currentPath = _.path.current();
  const srcProvider  = _.repo.providerForPath( o.src );
  _.sure( srcProvider.name === 'hd' )

  const localPath = _.path.join( currentPath, o.src );
  delete o.src;

  return _.git.commitsDates
  ({
    localPath,
    ... o,
  });
}

commitsDates.defaults =
{
  src : null,
  state1 : null,
  state2 : null,
  relative : 'now',
  delta : null,
  periodic : 0,
  deviation : 0,
};

// --
// fields
// --

let Composes =
{
};

let Aggregates =
{
};

let Associates =
{
};

let Restricts =
{
};

let Statics =
{
};

let Forbids =
{
};

let Accessors =
{
};

// --
// declare
// --

let Extension =
{

  // inter

  finit,
  init,

  //

  repositoryAgree,
  repositoryMigrate,

  //

  commitsDates,

  // relation

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,
  Accessors,
};

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

_.Copyable.mixin( Self );
_.Verbal.mixin( Self );

_realGlobal_[ Self.name ] = _global[ Self.name ] = Self;

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
