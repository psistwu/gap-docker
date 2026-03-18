# gap-docker
This repo creates and publishes docker images (based on Alpine Linux) that allows one
to run GAP-system within Jupyter Lab, a web-based IDE.

## Quickstart
1. Copy & paste `docker-compose.yaml` and `.env` to the project directory.
2. Modify `GAP_VERSION` and `JUPYTER_TOKEN` in `.env` if needed.
3. Start a container via `docker compose`.
4. Open Jupyter Lab via a web browser at `http://localhost:8888/lab`.
5. Log in Jupyter Lab with the token configured in `.env`.
6. Create a notebook with **GAP4** kernel.
7. Start to use GAP-system.
