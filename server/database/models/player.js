'use strict';
module.exports = (sequelize, DataTypes) => {
  var Player = sequelize.define('Player', {
    organization: DataTypes.STRING,
    name: DataTypes.STRING
  }, {});
  Player.associate = function(models) {
    // associations can be defined here
    Player.belongsToMany(models.Event, { through: models.Entries });
  };
  return Player;
};
