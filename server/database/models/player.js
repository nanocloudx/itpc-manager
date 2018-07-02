'use strict';
module.exports = (sequelize, DataTypes) => {
  var article = sequelize.define('player', {
    organization: DataTypes.STRING,
    name: DataTypes.STRING,
    status: DataTypes.STRING
  }, {});
  article.associate = function(models) {
    // associations can be defined here
  };
  return article;
};
