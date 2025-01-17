'use strict';
module.exports = (sequelize, DataTypes) => {
  var Event = sequelize.define('Event', {
    title: DataTypes.STRING,
    place: DataTypes.STRING,
    date: DataTypes.STRING
  }, {});
  Event.associate = function(models) {
    // associations can be defined here
    Event.belongsToMany(models.Player, { through: models.Entries });
  };
  return Event;
};
