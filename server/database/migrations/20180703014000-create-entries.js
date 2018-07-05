'use strict'

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('Entries', {
      id: {
        allowNull: false,
        defaultValue: Sequelize.UUIDV4,
        primaryKey: true,
        type: Sequelize.UUID
      },
      rank: {
        type: Sequelize.INTEGER
      },
      status: {
        type: Sequelize.STRING
      },
      EventId: {
        type: Sequelize.STRING,
        references: {
          model: 'Events',
          key: 'id'
        },
        onUpdate: 'cascade',
        onDelete: 'cascade'
      },
      PlayerId: {
        type: Sequelize.UUID,
        references: {
          model: 'Players',
          key: 'id'
        },
        onUpdate: 'cascade',
        onDelete: 'cascade'
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    }).then(() =>
      queryInterface.addIndex(
        'Entries',
        ['EventId', 'PlayerId'],
        { indicesType: 'UNIQUE' }
      )
    )
  },
  down: (queryInterface) => {
    return queryInterface.dropTable('Entries')
  }
}
