'use strict';
module.exports = (sequelize, DataTypes) => {
  var player = sequelize.define('player', {
    organization: DataTypes.STRING,
    name: DataTypes.STRING,
    status: DataTypes.STRING
  }, {});
  player.associate = function(models) {
    // associations can be defined here
  };
  return player;
};
