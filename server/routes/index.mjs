import express from 'express'
import createError from 'http-errors'
import db from './database'
import models from '../database/models'

const router = express.Router()

/**
 * イベント一覧
 */
router.get('/api/event', (req, res, next) => {
  httpResponse(db.findAll(models.event), res, next)
})

/**
 * プレーヤー一覧
 */
router.get('/api/event/:eventId/players', (req, res, next) => {
  httpResponse(db.findAll(models.player), res, next)
})

/**
 * プレーヤー情報
 */
router.get('/api/event/:eventId/players/:playerId', (req, res, next) => {
  httpResponse(db.findById(models.player, req.params.playerId), res, next)
})

/**
 * プレーヤー登録
 */
router.post('/api/event/:eventId/players/', (req, res, next) => {
  const context = {
    organization: req.body.organization,
    name: req.body.name,
    status: 'none'
  }
  httpResponse(db.create(models.player, context), res, next)
})

/**
 * プレーヤーゲーム開始
 */
router.put('/api/event/:eventId/players/:playerId/active', (req, res, next) => {
  httpResponse(db.update(models.player, req.params.playerId, { status: 'active' }), res, next)
})

/**
 * プレーヤーゲーム終了
 */
router.put('/api/event/:eventId/players/:playerId/finish', (req, res, next) => {
  httpResponse(db.update(models.player, req.params.playerId, { status: 'finish' }), res, next)
})

/**
 * プレーヤーゲーム中止
 */
router.put('/api/event/:eventId/players/:playerId/cancel', (req, res, next) => {
  httpResponse(db.update(models.player, req.params.playerId, { status: 'none' }), res, next)
})

/**
 * レンダリング
 */
router.get(['/'], (req, res, next) => {
  res.render('index')
})

function httpResponse (dbRequest, res, next) {
  dbRequest.then(results => { res.json(results) }).catch(err => { next(createError(404)) })
}

export default router
