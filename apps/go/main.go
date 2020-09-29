package main

import (
	"math"
	"strconv"
  "net/http"
  "github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	router.GET("/prime", func(c *gin.Context) {
		paramNo := c.Query("no") // shortcut for c.Request.URL.Query().Get("lastname")
		theNo, err := strconv.Atoi(paramNo)
    if err != nil {
				c.JSON(http.StatusBadRequest, gin.H{"no":paramNo, "error":err.Error() } )
    		return
		}
		
		var cal = math.Pow(10, float64(theNo))
		primes := sieveOfEratosthenes(int(cal))	
    c.JSON(http.StatusOK, gin.H{"no":theNo, "primes":len(primes),"time":0 })    
	})
	router.Run(":80")
}

func sieveOfEratosthenes(N int) (primes []int) {
	b := make([]bool, N)
	for i := 2; i < N; i++ {
			if b[i] == true { continue }
			primes = append(primes, i)
			for k := i * i; k < N; k += i {
					b[k] = true
			}
	}
	return
}