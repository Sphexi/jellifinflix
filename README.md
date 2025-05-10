# jellifinflix

**jellifinflix** is a downstream fork of [safiyu/jellifinflix](https://github.com/safiyu/jellifinflix), enhanced to support additional video file extensions for libraries with much older (but still supported) file types (ie AVI and MPG/MPEG).  There's also been minor updates re: personal preference, nothing that should affect the functionality of the app.

It will crawl through the `/media` directory, looking for subdirectories without ANY of the checked file types, and if it finds such a subdirectory it will create an empty `.ignore` file, which will cause Jellyfin to skip that directory when scanning for new media.  This is useful for directories that contain only images, or other non-video files.

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Sphexi/jellifinflix.git
   cd jellifinflix
   ```

2. **Update the docker-compose.yaml file:**

   - Update `volumes` to match your local media directory.  If your media directory is `/share/Media`, you would set it to:

     ```yaml
     volumes:
       - /share/Media:/media:rw
     ```
   - Set the `JF_API_KEY` environment variable to an API key from Jellyfin (Dashboard -> Advanced -> API Keys).
   - Set the `JF_URL` environment variable to the URL or IP address for your Jellyfin server (ie `jellyfin.domain.com` or `192.168.123.123`).

   ***Note:*** If you leave the API fields blank, the script will simply bypass the API call to force a rescan of media after each run.  This may cause delays in Jellyfin dropping empty directories, but it will still eventually work.

2. **Build and run the Docker container:**

   ```bash
   docker compose up -d --build
   ```

This command builds the Docker image and starts the container in detached mode.


## License

This project is licensed under the [GNU General Public License v3.0](LICENSE).