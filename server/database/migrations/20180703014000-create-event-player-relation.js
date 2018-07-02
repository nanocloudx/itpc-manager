'use strict'

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.createTable('event_player_relations', {
      id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.UUIDV4,
        primaryKey: true
      },
      rank: {
        type: Sequelize.INTEGER
      },
      eventId: {
        type: Sequelize.UUID,
        references: {
          model: 'events',
          key: 'id'
        },
        onUpdate: 'cascade',
        onDelete: 'cascade'
      },
      playerId: {
        type: Sequelize.UUID,
        references: {
          model: 'players',
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
        'event_player_relations',
        ['eventId', 'playerId'],
        { indicesType: 'UNIQUE' }
      )
    )
  },

  down: (queryInterface) => {
    return queryInterface.dropTable('event_player_relations')
  }
}
