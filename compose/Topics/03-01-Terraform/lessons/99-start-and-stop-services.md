docker-compose -f docker-compose-timestamp-no.yaml up

### Start services from docker-compose 

From the topic directory, run the following command line

location: ./compose/topics/<n-topics>
docker-compose -f <docker-compose-file> up

    ```bash
    docker-compose -f <"directory-name-location-docker-compose"+"volume-name-declared"."yaml"> up 
    docker-compose -f docker-compose.05.01.yaml up
    ```


2. **Switch to background mode:**

   ```bash
   docker-compose -f <"directory-name-location-docker-compose"+"volume-name-declared".yaml> up -d
   ```

3. **Check logs if needed:**

   ```bash
   docker-compose logs -f <container-name>
   ```

4. **Pause the cluster but keep data:**

   ```bash
   docker-compose stop
   ```

5. **Full cleanup (dangerous! wipes data):**

   ```bash
   docker-compose down -v
   ```
it means:

* **`down`** → stops and removes containers + default network created by `docker-compose up`
* **`-v` / `--volumes`** → also removes *named and anonymous volumes* declared in the `docker-compose.yml`
