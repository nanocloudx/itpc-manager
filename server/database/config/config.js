module.exports = {
  development: {
    database: 'itpc-manager',
    url: process.env.DATABASE_URL,
    dialect: 'postgres',
    dialectOptions: {
      timezone: '+09:00'
    }
  },
  production: {
    url: process.env.DATABASE_URL,
    dialect: 'postgres',
    dialectOptions: {
      ssl: {
        require: true
      },
      timezone: '+09:00'
    }
  }
}
