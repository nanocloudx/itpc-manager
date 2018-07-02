'use strict';
module.exports = (sequelize, DataTypes) => {
  var event = sequelize.define('event', {
    title: DataTypes.STRING,
    place: DataTypes.STRING,
    date: DataTypes.STRING
  }, {});
  event.associate = function(models) {
    // associations can be defined here
  };
  return event;
};
