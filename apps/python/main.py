from flask import Flask, json, request


companies = [{"id": 1, "name": "Company One"}, {"id": 2, "name": "Company Two"}]

api = Flask(__name__)


def SieveOfEratosthenes(n): 
      
    # Create a boolean array "prime[0..n]" and initialize 
    # all entries it as true. A value in prime[i] will 
    # finally be false if i is Not a prime, else true. 
    prime = [True for i in range(n + 1)] 
    primelist = []
    p = 2
    while (p * p <= n): 
          
        # If prime[p] is not changed, then it is a prime 
        if (prime[p] == True): 
              
            # Update all multiples of p 
            for i in range(p * 2, n + 1, p): 
                prime[i] = False
        p += 1
    prime[0]= False
    prime[1]= False
    # Print all prime numbers 
    for p in range(n + 1): 
        if prime[p]:
            primelist.append(p)  
            # print p, #Use print(p) for python 3 

    return len(primelist)
  


@api.route('/prime', methods=['GET'])
def get_companies():
    no = request.args.get('no')

    n = 10 ** int(no)
    prime = SieveOfEratosthenes(n)

    return json.dumps({"no": n , "prime": prime })

if __name__ == '__main__':
    api.run(host='0.0.0.0', port=8080)


