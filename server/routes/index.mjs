// import createError from 'http-errors'
import express from 'express'
import db from './database'
import models from '../database/models'

const router = express.Router()

/**
 * イベント一覧
 */
router.get('/api/events', (req, res, next) => {
  databaseResponse(db.findAll(models.Event), res, next)
})

/**
 * イベント情報
 */
router.get('/api/events/:eventId', (req, res, next) => {
  const schema = models.Event
  const where = {
    id: req.params.eventId
  }
  databaseResponse(db.findOne(schema, where), res, next)
})

/**
 * プレーヤー一覧
 */
router.get('/api/players', (req, res, next) => {
  databaseResponse(db.findAll(models.Player), res, next)
})

/**
 * プレーヤー情報
 */
router.get('/api/players/:playerId', (req, res, next) => {
  const schema = models.Player
  const where = {
    id: req.params.playerId
  }
  databaseResponse(db.findOne(schema, where), res, next)
})

/**
 * イベント参加者一覧
 */
router.get('/api/events/:eventId/players', async (req, res, next) => {

  // TODO リレーション実装ができないと一覧取得できない

  // const schema = models.EventPlayerRelation
  // const where = {
  //   EventId: req.params.eventId
  // }
  // databaseResponse(db.findAll(schema, where), res, next)
})

/**
 * イベント参加登録
 */
router.post('/api/events/:eventId/players/:playerId', (req, res, next) => {
  const schema = models.EventPlayerRelation
  const context = {
    EventId: req.params.eventId,
    PlayerId: req.params.playerId
  }
  databaseResponse(db.create(schema, context), res, next)
})

/**
 * イベント参加情報
 */
router.get('/api/events/:eventId/players/:playerId', async (req, res, next) => {

  // TODO この実装は良くない

  const EventPlayerRelation = await db.findOne(models.EventPlayerRelation, {
    EventId: req.params.eventId,
    PlayerId: req.params.playerId
  })
  const Player = await db.findOne(models.Player, {
    id: req.params.playerId
  })
  if (!EventPlayerRelation || !Player) {
    failureResponse(res)
    return
  }
  const result = {
    id: Player.id,
    organization: Player.organization,
    name: Player.name,
    rank: EventPlayerRelation.rank,
    status: EventPlayerRelation.rank
  }
  databaseResponse(Promise.resolve(result), res, next)
})

/**
 * ゲーム開始
 */
router.put('/api/events/:eventId/players/:playerId/active', async (req, res, next) => {
  const schema = models.EventPlayerRelation
  const where = {
    EventId: req.params.eventId,
    PlayerId: req.params.playerId
  }
  const context = {
    status: 'active'
  }
  const result = await db.update(schema, where, context)
  if (result[0] === 0) {
    failureResponse(res)
    return
  }
  successResponse(res)
})

/**
 * ゲーム終了
 */
router.put('/api/events/:eventId/players/:playerId/finish', async (req, res, next) => {
  const schema = models.EventPlayerRelation
  const where = {
    EventId: req.params.eventId,
    PlayerId: req.params.playerId
  }
  const context = {
    status: 'finish'
  }
  const result = await db.update(schema, where, context)
  if (result[0] === 0) {
    failureResponse(res)
    return
  }
  successResponse(res)
})

/**
 * ゲーム中止
 */
router.put('/api/events/:eventId/players/:playerId/cancel', async (req, res, next) => {
  const schema = models.EventPlayerRelation
  const where = {
    EventId: req.params.eventId,
    PlayerId: req.params.playerId
  }
  const context = {
    status: 'none'
  }
  const result = await db.update(schema, where, context)
  if (result[0] === 0) {
    failureResponse(res)
    return
  }
  successResponse(res)
})

/**
 * レンダリング
 */
router.get(['/'], (req, res, next) => {
  res.render('index')
})

function databaseResponse (dbRequest, res, next) {
  dbRequest.then(results => { res.json(results) }).catch(err => { next(err) })
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
