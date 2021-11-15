( function _Cui_s_()
{

'use strict';

//

const _ = _global_.wTools;
const Parent = null;
const Self = wRepoCui;
function wRepoCui( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'Cui';

// --
// inter
// --

function init( o )
{
  let cui = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  _.workpiece.initFields( cui );
  Object.preventExtensions( cui );

  if( o )
  cui.copy( o );
}

//

function Exec()
{
  let cui = new this.Self();
  return cui.exec();
}

//

function exec()
{
  let cui = this;

  _.assert( arguments.length === 0 );

  let appArgs = _.process.input();
  let ca = cui._commandsMake();

  return _.Consequence.Try( () =>
  {
    return ca.programPerform({ program : appArgs.original });
  })
  .catch( ( err ) =>
  {
    _.process.exitCode( -1 );
    logger.error( _.errOnce( err ) );
    _.procedure.terminationBegin();
    _.process.exit();
    return err;
  });
}

// --
// meta commands
// --

function _commandsMake()
{
  let cui = this;
  let appArgs = _.process.input();

  _.assert( _.instanceIs( cui ) );
  _.assert( arguments.length === 0 );

  let commands =
  {
    'help' :                    { ro : _.routineJoin( cui, cui.commandHelp ) },
    'version' :                 { ro : _.routineJoin( cui, cui.commandVersion ) },

    'agree' :                   { ro : _.routineJoin( cui, cui.commandAgree ) },
    'migrate' :                 { ro : _.routineJoin( cui, cui.commandMigrate ) },
  };

  let ca = _.CommandsAggregator
  ({
    basePath : _.path.current(),
    commands,
    commandsImplicitDelimiting : 1,
  });

  ca.form();

  ca.logger.verbosity = 0;

  return ca;
}

// --
// general commands
// --

function commandHelp( e )
{
  let cui = this;
  let ca = e.aggregator;

  ca._commandHelp( e );

  return cui;
}

var command = commandHelp.command = Object.create( null );
command.hint = 'Get help.';

//

function commandVersion( e )
{
  let cui = this;

  return _.npm.versionLog
  ({
    localPath : _.path.join( __dirname, '../../../../..' ),
    remotePath : 'wrepo!stable',
  });
}

var command = commandVersion.command = Object.create( null );
command.hint = 'Get information about version.';
command.subjectHint = false;

//

function commandAgree( e )
{
  const properties = e.propertiesMap;

  _.sure( _.str.defined( properties.srcPath ), 'Expects path to source repository.' );
  _.sure( _.str.defined( properties.withState ), 'Expects state to sync with.' );
  _.mapSupplementNulls( properties, commandAgree.defaults );

  return _.git.repositoryAgree
  ({
    srcPath : properties.srcPath || e.subject,
    localPath : properties.dstPath || _.path.current(),
    state2 : properties.withState,
    srcBase : properties.srcBase,
    dstBase : properties.dstBase,
    commitMessage : properties.message,
    mergeStrategy : properties.mergeStrategy,
    but : properties.but,
    only : properties.only,
    logger : 2,
  })
}

var command = commandAgree.command = Object.create( null );
commandAgree.defaults =
{
  srcBase : '.',
  dstBase : '.',
  mergeStrategy : 'src',
};
command.hint = 'Synchronize repository with another repository.';
command.subjectHint = 'Path to source repository.';
command.properties =
{
  srcPath : 'A path to source repository.',
  dstPath : 'A local path to destination repository. Default is current directory.',
  withState : 'A commit, tag or branch in source repository to sync with.',
  srcBase : 'A base directory for source repository. Filters changes in source repository in relation to this path. Default is source repository root directory.',
  dstBase : 'A base directory for destination repository. Checks difference in relation to this path. Default is destination repository root directory.',
  message : 'A commit message for synchronization commit. Optional.',
  mergeStrategy : 'A strategy to resolve conflicts in merged files. \n\tStrategies : \n\t`src` - apply external repository changes, \n\t`dst` - save original repository changes, \n\t`manual` - resolve conflicts manually. \n\tDefault is `src`.',
  but : 'A pattern or array of patterns to exclude from merge. Could be a glob.',
  only : 'A pattern or array of patterns to include in merge. Could be a glob.',
};

//

function commandMigrate( e )
{
  const properties = e.propertiesMap;

  _.sure( _.str.defined( properties.srcPath ), 'Expects path to source repository.' );
  _.sure( _.str.defined( properties.startState ), 'Expects start state to migrate commits.' );
  _.mapSupplementNulls( properties, commandMigrate.defaults );

  let onCommitMessage = properties.onMessage;
  if( onCommitMessage )
  onCommitMessage = require( _.path.join( _.path.current(), onCommitMessage ) );
  let onDate = properties.onMessage;
  if( onDate )
  onDate = require( _.path.join( _.path.current(), onDate ) );

  return _.git.repositoryMigrate
  ({
    srcPath : properties.srcPath || e.subject,
    localPath : properties.localPath || _.path.current(),
    state1 : properties.startState,
    state2 : properties.endState,
    srcBase : properties.srcBase,
    dstBase : properties.dstBase,
    onCommitMessage,
    onDate,
    but : properties.but,
    only : properties.only,
  })
}

var command = commandMigrate.command = Object.create( null );
commandMigrate.defaults =
{
  srcBase : '.',
  dstBase : '.',
};
command.hint = 'Migrate commits from one repository to another repository.';
command.subjectHint = 'Path to source repository.';
command.properties =
{
  srcPath : 'A path to source repository.',
  dstPath : 'A local path to destination repository. Default is current directory.',
  startState : 'A start commit.',
  endState : 'An end commit.',
  srcBase : 'A base directory for source repository. Filters changes in source repository in relation to this path. Default is source repository root directory.',
  dstBase : 'A base directory for destination repository. Checks difference in relation to this path. Default is destination repository root directory.',
  onMessage : 'A path to script that produce commit message. An original commit message will be passed to script. By default, command does not change commit message.',
  onDate : 'A path to script that produce commit date. An original string date will be passed to script. By default, command does not change commit date.',
  but : 'A pattern or array of patterns to exclude from merge. Could be a glob.',
  only : 'A pattern or array of patterns to include in merge. Could be a glob.',
};

// --
// relations
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
  Exec,
};

let Forbids =
{
};

// --
// declare
// --

let Extension =
{

  // inter

  init,
  Exec,
  exec,

  // meta commands

  _commandsMake,

  // general commands

  commandHelp,
  commandVersion,

  // migrate

  commandAgree,
  commandMigrate,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Statics,
  Forbids,

}

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

_.Copyable.mixin( Self );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.repo[ Self.shortName ] = Self;
if( !module.parent )
Self.Exec();

})();
