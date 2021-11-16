( function _Cui_s_()
{

'use strict';

//

const _ = _global_.wTools;
const Parent = wRepoBasic;
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
  const cui = this;
  const options = e.propertiesMap;

  _.sure( _.str.defined( options.src ), 'Expects path to source repository.' );
  _.sure( _.str.defined( options.dst ), 'Expects path to destination repository.' );
  _.mapSupplementNulls( options, commandAgree.defaults );

  return cui.repositoryAgree( options );
}

var command = commandAgree.command = Object.create( null );
commandAgree.defaults =
{
  srcDirPath : '.',
  dstDirPath : '.',
  mergeStrategy : 'src',
};
command.hint = 'Synchronize repository with another repository / directory.';
command.subjectHint = false;
command.properties =
{
  src : 'A path to source repository. Should contains a branch / tag / version to agree with.',
  dst : 'A local path to destination repository. Should contains a branch to merge changes',
  srcDirPath : 'A base directory for source repository. Filters changes in source repository in relation to this path. Default is source repository root directory.',
  dstDirPath : 'A base directory for destination repository. Checks difference in relation to this path. Default is destination repository root directory.',
  message : 'A commit message for synchronization commit. Optional.',
  mergeStrategy : 'A strategy to resolve conflicts in merged files. \n\tStrategies : \n\t`src` - apply external repository changes, \n\t`dst` - save original repository changes, \n\t`manual` - resolve conflicts manually. \n\tDefault is `src`.',
  but : 'A pattern or array of patterns to exclude from merge. Could be a glob.',
  only : 'A pattern or array of patterns to include in merge. Could be a glob.',
};

//

function commandMigrate( e )
{
  const cui = this;
  const options = e.propertiesMap;

  _.sure( _.str.defined( options.src ), 'Expects path to source repository.' );
  _.sure( _.str.defined( options.dst ), 'Expects path to destination repository.' );
  _.sure( _.str.defined( options.srcState1 ), 'Expects start state to migrate commits.' );
  _.mapSupplementNulls( options, commandMigrate.defaults );

  return cui.repositoryMigrate( options );
}

var command = commandMigrate.command = Object.create( null );
commandMigrate.defaults =
{
  srcDirPath : '.',
  dstDirPath : '.',
};
command.hint = 'Migrate commits from one repository to another repository.';
command.subjectHint = false;
command.properties =
{
  src : 'A path to source repository. Can contain branch name.',
  dst : 'A local path to destination repository.',
  srcState1 : 'A start commit.',
  srcState2 : 'An end commit. Optional, by default command reflects commit from start commit to last commit in branch.',
  srcDirPath : 'A base directory for source repository. Filters changes in source repository in relation to this path. Default is source repository root directory.',
  dstDirPath : 'A base directory for destination repository. Checks difference in relation to this path. Default is destination repository root directory.',
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

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_.repo[ Self.shortName ] = Self;
if( !module.parent )
Self.Exec();

})();
