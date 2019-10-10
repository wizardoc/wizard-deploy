const Koa = require('koa')
const Router = require('koa-router')
const BodyParser = require('koa-bodyparser')
const {exec} = require('shelljs')

const app = new Koa()
const router = new Router()

app.use(BodyParser())

router.post('/wizard/client/deploy', ctx => {
  exec('bash src/deploy/client.sh', (err, out) => {
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

  ctx.body = "deploy!"
})


app.use(router.routes()).use(router.allowedMethods())

app.listen(6666, () => console.info('deploy deamon is starting !'))