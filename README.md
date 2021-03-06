# Saturn L1 Node 🪐

Saturn L1 node is the outermost layer of the Saturn Network.
It allows retrieval clients to request CIDs and byte ranges of CIDs.
The node returns CAR files from cache or falls back to inner level nodes.

**Saturn is still in v0, but you can run a test-network node to help test Saturn today, we appreciate any and all feedback**


## Requirements

### General requirements
- Filecoin wallet address
- Email address

### Node's host requirements
- Linux server with a public IPv4 address
- Root access / passwordless sudo user
- Ports 80, 8080 and 443 free
- Docker installed ([Instructions here](https://docs.docker.com/engine/install/#server))
- Modern CPU with 4 cores (8+ cores recommended)
- 1Gbps upload bandwidth minimum (10Gbps+ recommended)<sup>1</sup>
- 16GB RAM minimum (64GB+ recommended)
- 1TB SSD minimum (4TB+ NVMe SSD in RAID0 recommended)<sup>2</sup>

<sub>
<sup>1</sup> The more you can serve &rarr; greater FIL earnings<br>
<sup>2</sup> Bigger disk &rarr; bigger cache &rarr; greater FIL earnings
</sub>


## Running a node

1. Install docker ([Instructions here](https://docs.docker.com/engine/install/#server))
2. Authenticate docker with the GitHub Container Registry ([Instructions here](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry))
3. Set FIL_WALLET_ADDRESS and NODE_OPERATOR_EMAIL env variables in `.bashrc` and `/etc/environment`
4. Run the docker image:

   **Test network:**
    ```shell
    sudo docker run --name saturn-node -it -d --restart=unless-stopped \
      -v $HOME/shared:/usr/src/app/shared \
      -e FIL_WALLET_ADDRESS=$FIL_WALLET_ADDRESS \
      -e NODE_OPERATOR_EMAIL=$NODE_OPERATOR_EMAIL \
      --network host \
      ghcr.io/filecoin-project/saturn-node:test
    ```

   **Main network (invitation only):**
    ```shell
    sudo docker run --name saturn-node -it -d --restart=unless-stopped \
      -v $HOME/shared:/usr/src/app/shared \
      -e FIL_WALLET_ADDRESS=$FIL_WALLET_ADDRESS \
      -e NODE_OPERATOR_EMAIL=$NODE_OPERATOR_EMAIL \
      --network host \
      ghcr.io/filecoin-project/saturn-node:main
    ```
    
5. Check logs with `docker logs -f saturn-node`
6. Wait for the sign up to happen with the orchestrator and the registration to DNS (this may take several minutes)
7. Download the [`update.sh`](update.sh) script

   ```shell
   wget -O $HOME/update.sh https://raw.githubusercontent.com/filecoin-project/saturn-node/main/update.sh && chmod +x $HOME/update.sh
   ```
8. **Main network:** Set `SATURN_NETWORK` to `main` in `.bashrc` and `/etc/environment`
9. Setup the cron to run every 5 minutes:

   ```shell
   crontab -e
   ```

   Add the following text:
   ```
   */5 * * * * $HOME/update.sh >> $HOME/cron.log
   ```

   **Make sure to have env variables set in `/etc/environment` or hardcoded in `update.sh` for auto-update to work**


## Developing

In development, to avoid an automatic CI/CD deployment to the test network when any change is made to the `container/` directory, include `[skip ci]` in the `git commit` message. Like:

```shell
git commit -m "my commit message [skip ci]"
```

### Build

Build the docker image with 
```shell
./node build
```

### Run

Run the docker container with 
```shell
./node run
```

### Build and run

```shell
./node build run
```

### Deployment

**Only changes to `container/` and `Dockerfile`** trigger a build

- To deploy to test network, just push to `main`.
- To deploy to main network, create a tag and push it, example:
  ```
  git checkout main
  git pull
  git tag $(date +%s)
  git push --follow-tags
  ```


## Files

#### nginx configuration

`nginx/` contains the nginx configuration of the caching proxy

#### Shim

`shim/` contains the necessary code to fetch CIDs and CAR files for nginx to cache 


## License

Dual-licensed under [MIT](https://github.com/filecoin-project/saturn-node/blob/master/LICENSE-MIT) + [Apache 2.0](https://github.com/filecoin-project/saturn-node/blob/master/LICENSE-APACHE)
