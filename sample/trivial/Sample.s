
const _ = require( 'wrepo' );

/* */

const utility = _.repo.Cui.Self();
const commandsAggregator = utility._commandsMake();
commandsAggregator.programPerform({ program : '.help' });

