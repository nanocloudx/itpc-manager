// import createError from 'http-errors'
import express from 'express'
import models from '../database/models'
import uuidv4 from 'uuid/v4'

const router = express.Router()

// TODO エラーハンドリング書いてないので暇な時にちゃんと直す

/**
 * イベント一覧
 */
router.get('/api/events', async (req, res, next) => {
  const results = await models.Event.findAll()
  databaseResponse(results, res)
})

/**
 * イベント情報
 */
router.get('/api/events/:eventId', async (req, res, next) => {
  const results = await models.Event.findById(req.params.eventId)
  databaseResponse(results, res)
})

/**
 * イベント登録
 */
router.post('/api/events', async (req, res, next) => {
  const results = await models.Event.create({
    id: req.body.id,
    title: req.body.title,
    place: req.body.place,
    date: req.body.date
  })
  databaseResponse(results, res)
})

/**
 * プレーヤー一覧
 */
router.get('/api/players', async (req, res, next) => {
  const results = await models.Player.findAll()
  databaseResponse(results, res)
})

/**
 * プレーヤー情報
 */
router.get('/api/players/:playerId', async (req, res, next) => {
  const results = await models.Player.findById(req.params.playerId)
  databaseResponse(results, res)
})

/**
 * プレーヤー登録
 */
router.post('/api/players', async (req, res, next) => {
  const results = await models.Player.create({
    id: uuidv4(),
    organization: req.body.organization,
    name: req.body.name
  })
  databaseResponse(results, res)
})

/**
 * イベント参加者一覧
 */
router.get('/api/events/:eventId/players', async (req, res, next) => {
  const results = await models.Event.findOne({
    include: [{
      model: models.Player,
      through: { attributes: ['rank', 'status'] }
    }],
    where: { id: req.params.eventId }
  })
  databaseResponse(results, res)
})

/**
 * イベント参加登録
 */
router.post('/api/events/:eventId/players/:playerId', async (req, res, next) => {
  const results = await models.EventPlayerRelation.create({
    id: uuidv4(),
    EventId: req.params.eventId,
    PlayerId: req.params.playerId
  })
  databaseResponse(results, res)
})

/**
 * イベント参加情報
 */
router.get('/api/events/:eventId/players/:playerId', async (req, res, next) => {
  const results = await models.Event.findOne({
    include: [{
      model: models.Player,
      through: { attributes: ['rank', 'status'] },
      where: { id: req.params.playerId }
    }],
    where: { id: req.params.eventId }
  })
  databaseResponse(results, res)
})

/**
 * ゲーム開始
 */
router.put('/api/events/:eventId/players/:playerId/playing', async (req, res, next) => {
  const result = await models.EventPlayerRelation.update({ status: 'playing' }, {
    where: {
      EventId: req.params.eventId,
      PlayerId: req.params.playerId
    }
  })
  if (result[0] === 0) {
    return failureResponse(res)
  }
  successResponse(res)
})

/**
 * ゲーム終了
 */
router.put('/api/events/:eventId/players/:playerId/finish', async (req, res, next) => {
  const result = await models.EventPlayerRelation.update({ status: 'finish' }, {
    where: {
      EventId: req.params.eventId,
      PlayerId: req.params.playerId
    }
  })
  if (result[0] === 0) {
    return failureResponse(res)
  }
  successResponse(res)
})

/**
 * ゲーム未参加
 */
router.put('/api/events/:eventId/players/:playerId/none', async (req, res, next) => {
  const result = await models.EventPlayerRelation.update({ status: 'none' }, {
    where: {
      EventId: req.params.eventId,
      PlayerId: req.params.playerId
    }
  })
  if (result[0] === 0) {
    return failureResponse(res)
  }
  successResponse(res)
})

/**
 * レンダリング
 */
router.get(['/'], (req, res, next) => {
  res.render('index')
})

function databaseResponse (results, res) {
  res.status(200)
  res.json(results)
}
function successResponse (res) {
  res.status(200)
  res.json({ status: 'success' })
}
function failureResponse (res) {
  res.status(404)
  res.json({ status: 'failure', error: 'not found' })
}

export default router
