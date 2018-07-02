'use strict';
module.exports = (sequelize, DataTypes) => {
  var EventPlayerRelation = sequelize.define('event_player_relation', {
    rank: DataTypes.INTEGER
  }, {});
  return EventPlayerRelation;
};
