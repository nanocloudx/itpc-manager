'use strict';
module.exports = (sequelize, DataTypes) => {
  var Entries = sequelize.define('Entries', {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true
    },
    finishTime: DataTypes.INTEGER,
    status: DataTypes.STRING
  }, {});
  Entries.associate = function(models) {
    // associations can be defined here
  };
  return Entries;
};
