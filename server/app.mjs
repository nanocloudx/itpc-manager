import createError from 'http-errors'
import express from 'express'
import path from 'path'
import cookieParser from 'cookie-parser'
import logger from 'morgan'

import dotenv from 'dotenv'
import helmet from 'helmet'
import compression from 'compression'
import indexRouter from './routes/index'

dotenv.config()
const __dirname = path.dirname(new URL(import.meta.url).pathname)
const app = express()

app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'hjs')

app.enable('trust proxy')
app.disable('x-powered-by')
app.use(helmet())
app.use(compression())
app.use(logger('dev'))
app.use(express.json())
app.use(express.urlencoded({ extended: false }))
app.use(cookieParser())
app.use(express.static(path.join(__dirname, '../public')))

// --------------------------------------------------
// ルーティング
// --------------------------------------------------
app.use('/', indexRouter)

// 404
app.use((req, res, next) => {
  next(createError(404))
})

// error
app.use((err, req, res, next) => {
  console.log(err)
  res.locals.message = err.message
  res.locals.error = req.app.get('env') === 'development' ? err : {}
  res.status(err.status || 500)
  res.render('error')
})

export default app
