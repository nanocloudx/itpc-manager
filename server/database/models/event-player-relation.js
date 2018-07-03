'use strict';
module.exports = (sequelize, DataTypes) => {
  var EventPlayerRelation = sequelize.define('EventPlayerRelation', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    rank: DataTypes.INTEGER,
    status: DataTypes.STRING
  }, {});
  EventPlayerRelation.associate = function(models) {
    // associations can be defined here
  };
  return EventPlayerRelation;
};
