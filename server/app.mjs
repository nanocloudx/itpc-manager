import createError from 'http-errors'
import express from 'express'
import path from 'path'
import cookieParser from 'cookie-parser'
import logger from 'morgan'

import dotenv from 'dotenv'
import helmet from 'helmet'
import compression from 'compression'
import session from 'express-session'
import csrf from 'csurf'
import Redis from 'ioredis'
import connectRedis from 'connect-redis'
import passport from 'passport'
import passportGithub from 'passport-github'
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
// セッション保持
// --------------------------------------------------
const redisClient = new Redis(process.env.REDIS_URL)
const RedisStore = connectRedis(session)
app.use(session({
  secret: 'itpcSecret',
  resave: false,
  saveUninitialized: false,
  store: new RedisStore({
    client: redisClient,
    prefix: 'session:',
    ttl: 60 * 60 * 24 * 3 // 3日間アクセスがない場合は Redis からセッション削除
  })
}))

// --------------------------------------------------
// githubログイン
// --------------------------------------------------
passport.use(new passportGithub.Strategy({
  clientID: process.env.GITHUB_OAUTH_CLIENT_ID,
  clientSecret: process.env.GITHUB_OAUTH_CLIENT_SECRET,
  callbackUrl: process.env.GITHUB_OAUTH_CLIENT_CALLBACK,
  scope: ['repo']
}, (accessToken, refreshToken, profile, cb) => {
  // 認証
  if (profile.id !== process.env.GITHUB_ADMIN_ID) {
    cb(createError(403))
    return
  }
  cb(null, { profile })
}))
passport.serializeUser((user, done) => {
  done(null, user)
})
passport.deserializeUser((user, done) => {
  done(null, user)
})

app.use(csrf())
app.use(passport.initialize())
app.use(passport.session())

// --------------------------------------------------
// ルーティング
// --------------------------------------------------
app.get('/auth/github', passport.authenticate('github'))
app.get('/auth/github/callback', passport.authenticate('github', {
  successRedirect: '/?auth=success',
  failureRedirect: '/?auth=failure'
}))
app.get('/auth/logout', (req, res) => {
  req.logout()
  res.redirect('/?auth=logout')
})

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
