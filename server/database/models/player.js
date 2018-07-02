'use strict';
module.exports = (sequelize, DataTypes) => {
  var Player = sequelize.define('player', {
    organization: DataTypes.STRING,
    name: DataTypes.STRING,
    status: DataTypes.STRING
  }, {});
  Player.associate = function(models) {
    // associations can be defined here
    Player.belongsToMany(models.Event, { through: models.EventPlayerRelation });
  };
  return Player;
};
