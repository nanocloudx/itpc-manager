import express from 'express'
import models from '../database/models'
import uuidv4 from 'uuid/v4'

const router = express.Router()

// TODO エラーハンドリング書いてないので暇な時にちゃんと直す

/**
 * API疎通確認
 */
router.get('/api/check', async (req, res, next) => {
  successResponse(res)
})

/**
 * イベント一覧
 */
router.get('/api/events', async (req, res, next) => {
  const results = await models.Event.findAll({ attributes: { exclude: ['createdAt', 'updatedAt'] } }).catch(err => {})
  if (!results) {
    return failureResponse(res)
  }
  databaseResponse(results, res)
})

/**
 * イベント情報
 */
router.get('/api/events/:eventId', async (req, res, next) => {
  const results = await models.Event.findById(req.params.eventId, { attributes: { exclude: ['createdAt', 'updatedAt'] } }).catch(err => {})
  if (!results) {
    return failureResponse(res)
  }
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
  }).catch(err => {})
  if (!results) {
    return failureResponse(res)
  }
  databaseResponse(results, res)
})

/**
 * プレーヤー一覧
 */
router.get('/api/players', async (req, res, next) => {
  const results = await models.Player.findAll({ attributes: { exclude: ['createdAt', 'updatedAt'] } })
  databaseResponse(results, res)
})

/**
 * プレーヤー情報
 */
router.get('/api/players/:playerId', async (req, res, next) => {
  const results = await models.Player.findById(req.params.playerId, { attributes: { exclude: ['createdAt', 'updatedAt'] } }).catch(err => {})
  if (!results) {
    return failureResponse(res)
  }
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
  }).catch(err => {})
  if (!results) {
    return failureResponse(res)
  }
  databaseResponse(results, res)
})

/**
 * イベント参加者一覧
 */
router.get('/api/events/:eventId/entries', async (req, res, next) => {
  const results = await models.Event.findOne({
    include: [{
      model: models.Player,
      through: { attributes: ['id', 'finishTime', 'status'] }
    }],
    where: { id: req.params.eventId }
  }).catch(err => {})
  if (!results) {
    return failureResponse(res)
  }
  const players = results.Players.map(player => {
    return {
      id: player.Entries.id,
      organization: player.organization,
      name: player.name,
      finishTime: player.Entries.finishTime,
      status: player.Entries.status
    }
  })
  databaseResponse(players, res)
})

/**
 * イベント参加登録
 */
router.post('/api/events/:eventId/entries', async (req, res, next) => {
  const results = await models.Entries.create({
    id: uuidv4(),
    EventId: req.params.eventId,
    PlayerId: req.body.playerId,
    status: 'none'
  }).catch(err => {})
  if (!results) {
    return failureResponse(res)
  }
  databaseResponse(results, res)
})

/**
 * イベント参加情報
 */
router.get('/api/events/:eventId/entries/:entryId', async (req, res, next) => {

  const check = await models.Entries.findById(req.params.entryId).catch(err => {})
  if (!check) {
    return failureResponse(res)
  }
  const results = await models.Event.findOne({
    include: [{
      model: models.Player,
      through: {
        where: { id: req.params.entryId },
        attributes: ['id', 'finishTime', 'status']
      }
    }],
    where: { id: req.params.eventId }
  }).catch(err => {})
  if (!results) {
    return failureResponse(res)
  }
  const player = {
    id: results.Players[0].Entries.id,
    organization: results.Players[0].organization,
    name: results.Players[0].name,
    finishTime: results.Players[0].Entries.finishTime,
    status: results.Players[0].Entries.status
  }
  databaseResponse(player, res)
})

/**
 * ゲーム開始
 */
router.put('/api/events/:eventId/entries/:entryId/playing', async (req, res, next) => {
  const results = await models.Entries.update({
    status: 'playing',
    finishTime: null
  }, {
    where: {
      id: req.params.entryId
    }
  }).catch(err => {})
  if (!results) {
    return failureResponse(res)
  }
  if (results[0] === 0) {
    return failureResponse(res)
  }
  successResponse(res)
})

/**
 * ゲーム終了
 */
router.put('/api/events/:eventId/entries/:entryId/finish', async (req, res, next) => {
  const results = await models.Entries.update({
    status: 'finish',
    finishTime: Math.floor(new Date().getTime() / 1000)
  }, {
    where: {
      id: req.params.entryId
    }
  }).catch(err => {})
  if (!results) {
    return failureResponse(res)
  }
  if (results[0] === 0) {
    return failureResponse(res)
  }
  successResponse(res)
})

/**
 * ゲーム未参加
 */
router.put('/api/events/:eventId/entries/:entryId/none', async (req, res, next) => {
  const results = await models.Entries.update({
    status: 'none',
    finishTime: null
  }, {
    where: {
      id: req.params.entryId
    }
  }).catch(err => {})
  if (!results) {
    return failureResponse(res)
  }
  if (results[0] === 0) {
    return failureResponse(res)
  }
  successResponse(res)
})

/**
 * レンダリング
 */
router.get(['*'], (req, res, next) => {
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
