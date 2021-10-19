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

  cui._command_head( commandVersion, arguments );

  return _.npm.versionLog
  ({
    localPath : _.path.join( __dirname, '../../../../..' ),
    remotePath : 'wrepo!stable',
  });
}

var command = commandVersion.command = Object.create( null );
command.hint = 'Get information about version.';
command.subjectHint = false;

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
