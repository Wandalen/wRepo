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

  const srcParsed = _.git.path.parse( o.src );
  _.sure( srcParsed.tag !== undefined || srcParsed.hash !== undefined );
  const dstParsed = _.git.path.parse( o.dst );
  _.sure( dstParsed.tag !== undefined, 'Expects defined branch in path {-dst-}' );

  const nativized = _.git.path.nativize( o.dst );
  const tagDescriptor = _.git.tagExplain
  ({
    remotePath : o.dst,
    localPath : nativized,
    tag : dstParsed.tag,
    remote : 0,
    local : 1,
  });
  _.sure( tagDescriptor.isBranch, `Expects branch but got tag ${ dstParsed.tag }` );

  return _.git.repositoryAgree
  ({
    srcBasePath : o.src,
    dstBasePath : nativized,
    srcState : srcParsed.tag ? `!${ srcParsed.tag }` : `#${ srcParsed.hash }`,
    srcDirPath : o.srcDirPath,
    dstDirPath : o.dstDirPath,
    commitMessage : o.message,
    mergeStrategy : o.mergeStrategy,
    but : o.but,
    only : o.only,
    logger : 2,
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

  const srcParsed = _.git.path.parse( o.src );
  _.sure( srcParsed.tag !== undefined );
  const dstParsed = _.git.path.parse( o.dst );
  _.sure( dstParsed.tag !== undefined, 'Expects defined branch in path {-dst-}' );

  const nativized = _.git.path.nativize( o.dst );
  const tagDescriptor = _.git.tagExplain
  ({
    remotePath : o.dst,
    localPath : nativized,
    tag : dstParsed.tag,
    remote : 0,
    local : 1,
  });
  _.sure( tagDescriptor.isBranch, `Expects branch but got tag ${ dstParsed.tag }` );

  let onCommitMessage = o.onMessage;
  if( onCommitMessage )
  onCommitMessage = require( _.path.join( _.path.current(), onCommitMessage ) );
  let onDate = o.onMessage;
  if( onDate )
  onDate = require( _.path.join( _.path.current(), onDate ) );

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
  onMessage : null,
  onDate : null,
  but : null,
  only : null,
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
