# AKS deployment Trial

> I use AWS ECS for most of my cloud deployments , this repo consists of the code which I wrote to try out the Azure AKS.

> The Apps directory has four sample apps which are written in Go, Python, Node & Deno respectively. All those are containerised and uploaded to dockerhub. You can view those images at [hub.docker.com/u/vazra](https://hub.docker.com/u/vazra)

> those are simple apps to calculate no of prime numbers under under 10^n . it can be called as an api with endpoint `/prime?no=3` when no is the n. it's a compute heavy calculation, so the part of the intention was to check how that performs in different languages.

### Steps

1. Create sample applications in python,go,node and deno
2. dockerize the applications.

   ```
    # node app
    docker build -t vazra/prime-py .
    docker run -p 8080:8080 -d vazra/prime-py
    docker login -u vazra --password-stdin
    # python app
    docker build -t vazra/prime-py .
    docker run -p 8080:8080 -d vazra/prime-py
    docker push vazra/prime-py
    # deno app
    docker build -t vazra/prime-deno .
    docker run -p 8080:8080 -d vazra/prime-deno
    docker push vazra/prime-deno
   ```

3. Craete aks cluster with `./create-aks-cluster`
   - If you want to try this out change the subscription id and other parameters in the script and run.
4. Try out all the endpoints: Out of the four options Go app is performing much better than other three, in both memory and cpu usage and in time.
5. Once everything in done delete the cluster.
