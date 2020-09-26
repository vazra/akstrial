const express = require('express')
const path = require('path')
const app = express()

const PORT = process.env.PORT || 8080
const NODE_ENV = process.env.NODE_ENV || 'development'

app.set('port', PORT)
app.set('env', NODE_ENV)

app.get('/prime', (req, res, next) => {
  let no = req.query.no
  const theNo = Math.pow(10, +no)
  var resparr = sieveOfEratosthenes(theNo)
  res.json({ no: +no, primes: resparr.length })
})

app.use((req, res, next) => {
  const err = new Error(`${req.method} ${req.url} Not Found`)
  err.status = 404
  next(err)
})

app.use((err, req, res, next) => {
  console.error(err)
  res.status(err.status || 500)
  res.json({
    error: {
      message: err.message,
    },
  })
})

app.listen(PORT, () => {
  console.log(`Express Server started on Port ${app.get('port')} | Environment : ${app.get('env')}`)
})

var sieveOfEratosthenes = function (n) {
  // Eratosthenes algorithm to find all primes under n
  var array = [],
    upperLimit = Math.sqrt(n),
    output = []

  // Make an array from 2 to (n - 1)
  for (var i = 0; i < n; i++) {
    array.push(true)
  }

  // Remove multiples of primes starting from 2, 3, 5,...
  for (var i = 2; i <= upperLimit; i++) {
    if (array[i]) {
      for (var j = i * i; j < n; j += i) {
        array[j] = false
      }
    }
  }

  // All array[i] set to true are primes
  for (var i = 2; i < n; i++) {
    if (array[i]) {
      output.push(i)
    }
  }

  return output
}
