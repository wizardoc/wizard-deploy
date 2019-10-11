const Koa = require('koa')
const Router = require('koa-router')
const BodyParser = require('koa-bodyparser')
const {exec} = require('shelljs')

const app = new Koa()
const router = new Router()

app.use(BodyParser())

const commander = (ctx, shellName) => {
  exec(`bash src/deploy/${shellName}.sh`, (err, out) => {
    if(err){
      ctx.res.statusCode = 500
      ctx.body = "Server Internal Error"

      return
    }

    process.stderr.write(err.toString());
    process.stdout.write(out.toString());
    
    ctx.res.statusCode = 200
    ctx.body = "done!"
  })
}

router.post('/wizard/client/deploy', ctx => {
  commander(ctx,'client')

  ctx.body = "deploy!"
})

router.post('/wizard/server/deploy', ctx => {
  commander(ctx,'server')

  ctx.body = "deploy!"
})


app.use(router.routes()).use(router.allowedMethods())

app.listen(6666, () => console.info('deploy deamon is starting !'))