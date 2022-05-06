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

    'commits dates' :           { ro : _.routineJoin( cui, cui.commandCommitsDates ) },
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
command.propertiesAliases =
{
  verbosity : [ 'v' ]
};
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
  relative : 'An option that define what date is used to apply delta. Option accepts values `now` and `commit`.\n\t`now` - time delta applies to current date.\n\t`commit` - time delta applies to commit author date.\n\tDefault is `commit`.',
  delta : 'An option that define time delta that will be added to commit offset time. Accepts time in the next formats:\n\t- number in miliseconds. Example: 60000;\n\t- format "hh:mm:ss". Example: 00:01:00;\n\t- combination of time units: `d` - days, `h` - hours, `m` - minutes, `s` - seconds. Example: 2d 1h 3m.',
  verbosity : 'Set verbosity. Default is 1.',
  dry : 'Dry run without changes in repository. Default is 0. If `dry` is 1, then command will print list of files to change.',
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
command.propertiesAliases =
{
  verbosity : [ 'v' ]
};
command.properties =
{
  src : 'A path to source repository. Can contain branch name.',
  dst : 'A local path to destination repository.',
  srcState1 : 'A start commit.',
  srcState2 : 'An end commit. Optional, by default command reflects commit from start commit to last commit in branch.',
  srcDirPath : 'A base directory for source repository. Filters changes in source repository in relation to this path. Default is source repository root directory.',
  dstDirPath : 'A base directory for destination repository. Checks difference in relation to this path. Default is destination repository root directory.',
  but : 'A pattern or array of patterns to exclude from merge. Could be a glob.',
  only : 'A pattern or array of patterns to include in merge. Could be a glob.',
  onMessage : 'A path to script that produce commit message. An original commit message will be passed to script. By default, command does not change commit message.',
  onDate : 'An option for modifying commit dates. Accepts values : `construct` and path to script.\n\t`construct` - callback will be constructed from options `relative`, `delta`, `periodic` and `deviation`. \n\tOtherwise, utility uses script in option. An original string date will be passed to script.\n\tBy default, command does not change commit date.',
  relative : 'An option that define what date is used to apply delta. Option accepts values `now` and `commit`.\n\t`now` - time delta applies to current date.\n\t`commit` - time delta applies to commit author date.\n\tDefault is `commit`.',
  delta : 'An option that define time delta that will be added to commit offset time. Accepts time in the next formats:\n\t- number in miliseconds. Example: 60000;\n\t- format "hh:mm:ss". Example: 00:01:00;\n\t- combination of time units: `d` - days, `h` - hours, `m` - minutes, `s` - seconds. Example: 2d 1h 3m.',
  periodic : 'If option is defined, the commits will be written with defined period, start date is a sum of relative time and delta. Accepts number in miliseconds and format "hh:mm:ss".',
  deviation : 'Option works with option `periodic`, defines deviation of commit date. Commits will be written with random date in defined date range. Accepts time in the next formats:\n\t- number in miliseconds. Example: 60000;\n\t- format "hh:mm:ss". Example: 00:01:00;\n\t- combination of time units: `d` - days, `h` - hours, `m` - minutes, `s` - seconds. Example: 2d 1h 3m.',
  verbosity : 'Set verbosity. Default is 1.',
  dry : 'Dry run without changes in repository. Default is 0. If `dry` is 1, then command will print list of files to change.',
};

//

function commandCommitsDates( e )
{
  const cui = this;
  const options = e.propertiesMap;

  _.sure( _.str.defined( options.src ), 'Expects path to source repository.' );
  _.sure( _.str.defined( options.state1 ), 'Expects start state to migrate commits.' );
  _.sure( options.delta !== undefined, 'Expects time delta.' );

  return cui.commitsDates( options );
}

var command = commandCommitsDates.command = Object.create( null );
command.hint = 'Rewrite commits author date in local repository.';
command.subjectHint = false;
command.properties =
{
  src : 'A path to local repository. Can contains branch name.',
  state1 : 'A start commit.',
  state2 : 'An end commit. Optional, by default command changes commits from start commit to last commit in branch.',
  relative : 'Define what date will be modified and applied to commit. Accepts two options : "now" - current date, "commit" - commit date. Default is "now".',
  delta : 'Define the time delta that applied to modified date. Accepts delta in the next formats:\n\t- number in miliseconds. Example: 60000;\n\t- format "hh:mm:ss". Example: 00:01:00;\n\t- combination of time units: `d` - days, `h` - hours, `m` - minutes, `s` - seconds. Example: 2d 1h 3m.\n\tIf option `periodic` is enabled, than the option is used to calculate start date to write commits periodically.',
  periodic : 'Define the time period in which commits will be committed. Accepts time in milliseconds or in format "hh:mm:ss".',
  deviation : 'Define deviation for periodically created commits. Accepts time in the next formats:\n\t- number in miliseconds. Example: 60000;\n\t- format "hh:mm:ss". Example: 00:01:00;\n\t- combination of time units: `d` - days, `h` - hours, `m` - minutes, `s` - seconds. Example: 2d 1h 3m.',
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

  // commits

  commandCommitsDates,

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
