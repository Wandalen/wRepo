#! /usr/bin/env node

/**
 * Utility to work with remote git repositories.
 * @module Tools/top/Repo
 */

const _ = require( '../include/Top.s' );
module[ 'exports' ] = _;
if( !module.parent )
_.repo.Cui.Exec();
