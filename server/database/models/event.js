'use strict';
module.exports = (sequelize, DataTypes) => {
  var Event = sequelize.define('event', {
    title: DataTypes.STRING,
    place: DataTypes.STRING,
    date: DataTypes.STRING
  }, {});
  Event.associate = function(models) {
    // associations can be defined here
    Event.belongsToMany(models.Player, { through: models.EventPlayerRelation });
  };
  return Event;
};
